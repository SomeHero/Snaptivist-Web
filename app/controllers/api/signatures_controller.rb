class Api::SignaturesController < ApplicationController
  #before_filter :authenticate_user!, :only => [:create]
  respond_to :json

  API_VERSION = '1.0'

  def create

   @petition = Petition.find(params[:petition_id])

   if(params[:authentication_mechanism] == 'facebook')
     graph = Koala::Facebook::GraphAPI.new(params[:access_token])
     @fb_user = graph.get_object("me")

     Rails.logger.debug @fb_user["email"]
     Rails.logger.debug @fb_user["first_name"]
     Rails.logger.debug @fb_user["last_name"]

     email = @fb_user["email"]
     first_name = @fb_user["first_name"]
     last_name = @fb_user["last_name"]

     @external_account = ExternalAccount.find_by_external_id(params[:external_id])
     
     if(!@external_account)
      @external_account = ExternalAccount.new do |e|
        e.external_id = params[:external_id]
        e.type = 'FacebookAccount'
        e.email = params[:email]
        e.authenticated_at = Time.now
        e.allowed_at = Time.now
      end

      @user = User.find_by_email(params[:email])

      if(!@user)
        
        @user = User.new do |u|
          u.first_name = first_name
          u.last_name = last_name
          u.email = email
          u.password = "password"
          u.password_confirmation = "password"
          u.zip_code = ""

          u.external_accounts << @external_account
        end
      else
        @user = @external_account.user
      end
    end 
  else
   if(params[:user_id])
    @user = User.find(params[:user_id])
  else
    @user = User.find_by_email(params[:email])
  end

  if(!@user)
   @user = User.new do |u|
    u.first_name = params[:first_name]
    u.last_name = params[:last_name]
    u.email = params[:email]
    u.password = "password"
    u.password_confirmation = "password"
    u.zip_code = params[:zip_code]
  end
end
end

    #auth_mechanism = params.fetch(:auth_mechanism, 'standard')
    @signature = Signature.new do |s|
      s.user = @user
      s.petition = @petition
      s.comment = params[:comment]
    end

    if !@signature.valid?
     return render_result({}, 400, 'Error Signing Petition')
   end

    #return if error_messages?(:config)

    @signature.save
    
    render_result({'signature' => {'id' => @signature.id,
      #'user' => @signature.user,
      'comments' => @signature.comment
      }})

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