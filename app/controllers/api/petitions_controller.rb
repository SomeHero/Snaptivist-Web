
class Api::PetitionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :share]

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
        else
         @user = User.new do |u|
          u.first_name = params[:first_name]
          u.last_name = params[:last_name]
          u.email = params[:email_address]
          u.password = "password"
          u.password_confirmation = "password"
          u.zip_code = params[:zip_code]
          end
        end

        sign_in @user

      end

      raise "Unable to find user" unless current_user

      signature = @petition.signatures.new do |s|
        s.user = current_user
        s.comment = params[:comment]
      end


    if !signature.valid?
     return render_result({}, 400, 'Error Signing Petition')
    end

    #return if error_messages?(:config)
    @petition.save

    render_result(@petition.to_api)
  end

  #render a petition with id = params[:id]
  def show
    @petition = Petition.find(params[:id])

    raise Error404 unless @petition

    render_result(@petition.to_api)
  end

	# render a result in the appropriate format
  # TODO: move to some base class or something
	def render_result(result = {}, status = 200, status_string = 'OK')
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
