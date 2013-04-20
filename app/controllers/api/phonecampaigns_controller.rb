class Api::PhonecampaignsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :share]

  respond_to :json

  API_VERSION = '1.0'
 
  def create

    #create a new phone campaign
    @phone_campaign = PhoneCampaign.new do |p|
    	p.user = current_user
      p.title = params[:title]
    	p.summary = params[:summary]
    	p.target_count =100
      p.target_id = params[:target_id]
      p.call_results_count = 0
      p.rewrite_url_key = params[:title].gsub(" ", "-")
    end

    #make sure it is valid else exit with error
    if !@phone_campaign.valid?
     return render_result({}, 400, @phone_campaign.errors)
    end

    #save it to the db to get ID
    @phone_campaign.save
    
    #create a bitly url TODO: refactor
    @phone_campaign.short_url = @phone_campaign.shorten_url

    #save it again
    @phone_campaign.save!
    
    #render the phone campaign as json
    render_result(@phone_campaign.to_api)

  end

  def share

    #handle to tweating here
    @phonecampaign = PhoneCampaign.find(params[:id]); 
    raise "Unable to find petition" unless @phonecampaign

    @callresult = CallResult.find(params[:callresult_id])
    rails "Unable to find signature" unless @callresult
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

    @callresult.delivered = true
    @callresult.delivered_at = Time.now

    @callresult.save!

    render_result()

    end
  end

  #log a call_result; this endpoint is used when someone takes an action
  def log

    @phone_campaign = PhoneCampaign.find(params[:id]);

      raise "Unable to find phone campaign" unless @phone_campaign

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

      call_result = @phone_campaign.call_results.new do |s|
        s.user = current_user
        s.comment = params[:comment]
      end


    if !call_result.valid?
     return render_result({}, 400, 'Error Save Call Results')
    end

    #return if error_messages?(:config)
    call_result.save!

    #send petition action email
    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME, :user => current_user)

    render_result({ 'phone_campaign' => @phone_campaign.to_api,
                    'call_result' => call_result.to_api})
  end

  def show
    @phone_campaign = PhoneCampaign.find(params[:id])

    raise Error404 unless @phone_campaign

    render_result(@phone_campaign.to_api)
  end

	# render a result in the appropriate format
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