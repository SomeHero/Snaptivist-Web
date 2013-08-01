require 'koala'


class Api::PetitionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :share, :sign_another]

  respond_to :json

  #the version of the API
  #TODO: refactor to base class or something
  API_VERSION = '1.0'

  #creates a new petition with a given target, title, summary and generates a new bitly url
  #for the petition
 def create

    #auth_mechanism = params.fetch(:auth_mechanism, 'standard')
    @petition = Petition.new do |p|
      p.user = current_user
    	p.title = params[:title]
    	p.summary = params[:summary]
    	p.target_count =100
      p.signatures_count = 0
      p.target_id = params[:target_id]
      p.rewrite_url_key = params[:title].gsub(" ", "-")
    end

    if !@petition.valid?
     return render_result({}, 400, @petition.errors)
   end

    #return if error_messages?(:config)

    @petition.save

    @petition.short_url = @petition.shorten_url

    @petition.save!
    
    render_result(@petition.to_api)

  end

  #delivers the signature to a target via twitter
  #TODO: rename to deliver also may want to refactor
  def share

    @petition = Petition.find(params[:id]); 
    raise "Unable to find petition" unless @petition

    @signature = Signature.find(params[:signature_id])
    raise "Unable to find signature" unless @signature
    #handle to tweating here
    #if params[:tweet]
    token = current_user.authentications.find_by_provider("twitter").token
    token_secret = current_user.authentications.find_by_provider("twitter").token_secret

    Twitter.configure do |config|
      config.consumer_key = 'JRkoDk6R3BxPpmu5sIsKLA'
      config.consumer_secret = 'AUApr8ShZz9qGT0Xfsq6GKruD0rxunZGUCJUs0wXmo'
      config.oauth_token = token
     config.oauth_token_secret = token_secret

    Twitter.update(params[:tweet])

    @signature.delivered = true
    @signature.delivered_at = Time.now

    @signature.save!

    render_result()

    end
  end

  #adds a Signature to a petition
  #can be called with email address in which case we will look for the user account
  #with that email address or create a new one
  #if not called with email we are assuming the user has authenticated their account
  #via Facebook or possibly some other social network
  def sign

      @petition = Petition.find(params[:id]);

      raise "Unable to find petition" unless @petition

      if params[:email_address]

        @user = User.find_by_email(params[:email_address])

        if @user
          @user.first_name = params[:first_name]
          @user.last_name = params[:last_name]
          @user.zip_code = params[:zip_code]
          if @user.action_tags
            @user.action_tags += "," + @petition.action_tags
          else
            @user.action_tags = @petition.action_tags
          end
          @user.save!

        else
         @user = User.new do |u|
          u.first_name = params[:first_name]
          u.last_name = params[:last_name]
          u.email = params[:email_address]
          u.password = "password"
          u.password_confirmation = "password"
          u.zip_code = params[:zip_code]
          u.action_tags = @petition.action_tags
          end

          @user.save!

        end

      end

      signature = @petition.signatures.new do |s|
        s.user = @user
        s.signature_method = "Email"
        s.latitude = params[:latitude]
        s.longitude = params[:longitude]
        s.zip_code = params[:zip_code]
        s.comment = params[:comment]
        s.opt_in = params[:opt_in]
      end


    if !signature.valid?
     return render_result({}, 400, 'Error Signing Petition')
    end

    #return if error_messages?(:config)
    @petition.save
    @petition.reload

    #send petition action email
    if signature.opt_in
      UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME, :user => @user, :merge_fields => {
            "merge_petitiontitle" => @petition.title,
            "merge_firstname" => @user.first_name,
            "merge_lastname" => @user.last_name,
            "merge_targetname" => @petition.target.title + " " + @petition.target.last_name,
            "merge_shorturl" => @petition.short_url,
            "merge_organizationname" => @petition.user.organization_name,
            "merge_organizationavatar" => @petition.user.organization_avatar("medium")
        })
    end

    sign_in @user

    render_result({ 'petition' => @petition.to_api,
                    'signature' => signature.to_api})

  end

  #end point to sign a petition using a facebook account; you must present a facebook user id, token;
  #this method will take care of the rest, if no user exists with with that facebook id, we'll create one and
  #sign the petition; otherwise just sign
  def sign_with_facebook
    
    petition = Petition.find(params[:id])
    
    raise "Unable to find petition" unless petition

    Rails.logger.debug "The access token is " + params[:accessToken]

    #see if we have this FB user in the authentications table
    authentication = Authentication.find_by_provider_and_uid('facebook', params[:userID])

    @graph =Koala::Facebook::API.new(params[:accessToken])
    facebook_profile = @graph.get_object("me")

    raise "Unable to retrieve Facebook profile" unless facebook_profile

    if authentication
      #flash[:notice] = "Logged in Successfully"
      user = User.find(authentication.user_id)
      user.first_name = facebook_profile['first_name']
      user.last_name = facebook_profile['last_name']
      user.avatar_url = "http://graph.facebook.com/" + params[:userID] + "/picture"
      if user.action_tags
        user.action_tags += "," + petition.action_tags
      else
        user.action_tags = petition.action_tags
      end
      user.save!

    else
      user = User.new
      user.email =  facebook_profile["email"]
      user.first_name = facebook_profile['first_name']
      user.last_name = facebook_profile['last_name']
      user.avatar_url = "http://graph.facebook.com/" + params[:userID] + "/picture"
      user.password = "James123"
      user.action_tags = petition.action_tags
      
      user.authentications.build(
          :provider => 'facebook', 
          :uid => params[:userID], 
          :token => params[:accessToken], 
          :token_secret => params[:token_secret])

      user.save!


    end

    raise "Unable to find user" unless user

    signature = user.signatures.find_by_petition_id(petition.id)

    unless signature
      signature = petition.signatures.new do |s|
        s.user = user
        s.signature_method = "Facebook"
        s.latitude = params[:latitude]
        s.longitude = params[:longitude]
        s.comment = params[:comment]
        s.opt_in = params[:opt_in]

        if facebook_profile["location"]
          s.city = facebook_profile["location"]["name"].split(",")[0]
          s.state = facebook_profile["location"]["name"].split(",")[1]
        end
      end


      if !signature.valid?
        return render_result({}, 400, 'Error Signing Petition')
      end

      #return if error_messages?(:config)
      petition.save

      #send petition action email
      if signature.opt_in
        UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME, :user => user, :merge_fields => {
            "merge_petitiontitle" => petition.title,
            "merge_firstname" => user.first_name,
            "merge_lastname" => user.last_name,
            "merge_targetname" => petition.target.title + " " + petition.target.last_name,
            "merge_shorturl" => petition.short_url,
            "merge_organizationname" => petition.user.organization_name,
            "merge_organizationavatar" => petition.user.organization_avatar("medium")
        })
      end

    end

    sign_in user

    render_result({ 'petition' => petition.to_api,
      'signature' => signature.to_api})

  end

  def share_with_facebook

    @petition = Petition.find(params[:id]); 
    raise "Unable to find petition" unless @petition

    @signature = Signature.find(params[:signature_id])
    raise "Unable to find signature" unless @signature

    @signature.shared = true
    @signature.shared_at = Time.now

    @signature.save!

    render_result()

  end

  def sign_another

    petition = Petition.find(params[:id]);

    raise "Unable to find petition" unless petition

    signature = current_user.signatures.find_by_petition_id(petition.id)
    last_signature = current_user.signatures.last

    signature_method = ""

    if last_signature 
      signature_method = last_signature.signature_method
    end

    unless signature
      signature = petition.signatures.new do |s|
        s.user = current_user
        s.zip_code = current_user.zip_code
        s.comment = params[:comment]
        s.opt_in = params[:opt_in]
        s.signature_method = signature_method
      end

      if !signature.valid?
        return render_result({}, 400, 'Error Signing Petition')
      end

      #return if error_messages?(:config)
      petition.save

      if signature.opt_in
      #send petition action email
        UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME, :user => current_user, :merge_fields => {
            "merge_petitiontitle" => petition.title,
            "merge_firstname" => current_user.first_name,
            "merge_lastname" => current_user.last_name,
            "merge_targetname" => petition.target.title + " " + petition.target.last_name,
            "merge_shorturl" => petition.short_url,
            "merge_organizationname" => petition.user.organization_name,
            "merge_organizationavatar" => petition.user.organization_avatar("medium")
        })
      end

    end

    render_result({ 'petition' => petition.to_api,
        'signature' => signature.to_api})


  end

  def signatures
    @petition = Petition.find(params[:id])

    page_size = 10
    offset = 0

    if params[:offset]
      offset = params[:offset]
    end

    @signatures = @petition.signatures.limit(page_size).offset(offset)

    result = {
      signatures: @signatures.map { |s| s.to_api },
      total: Signature.find_all_by_petition_id(@petition.id).count
    }

    render_result result

  end

  #render a petition with id = params[:id]
  def show
    @petition = Petition.includes("user")
      .find(params[:id])

    raise Error404 unless @petition

    render_result(@petition.to_api)
  end

    #render a petition with id = params[:id]
  def index
    @petition = Petition.find(params[:id])

    raise Error404 unless @petition

    render_result(@petition.to_api)
  end

  def more
    @petitions = Petition.all()

    result = {
      petitions: @petitions.map { |p| p.to_api }
    }

    render_result(result)

  end

	# render a result in the appropriate format
  # TODO: move to some base class or something
	def render_result(result = {}, status = 200, status_string = 'OK')

    Rails.logger.debug "Rendering results " + result.inspect

		return_value = {'version' => API_VERSION,
			'statusCode' => status,
			'statusString' => status_string,
			'result' => result}
			if params[:callback]
				render :text => "#{params[:callback]}(#{return_value.to_json});", :content_type => "application/javascript"
			elsif params[:isIEPhoto]
				render :text=> return_value.to_json, :content_type => "text/plain"
			else
				render :json => return_value.to_json
			end
		end

	end
