class Api::AuthenticationsController < ApplicationController

  def index
    @authentications = current_user.authentications.all
  end
  
  def home

  end
  
  def twitter
    binding.pry
    raise "Unable to find user" unless current_user

    #raise omni = request.env["omniauth.auth"].to_yaml
    omni = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

    if authentication
     #flash[:notice] = "Logged in Successfully"
     sign_in User.find(authentication.user_id)

     return render 'oauth_popup_close', :layout => false            
   elsif current_user
     token = omni['credentials'].token
     token_secret = omni['credentials'].secret

     current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
     #flash[:notice] = "Authentication successful."
     sign_in current_user

     return render 'oauth_popup_close', :layout => false            
     
   else
     user = User.new 
     user.email = omni['info'].name
     user.apply_omniauth(omni)

     if user.save
       #flash[:notice] = "Logged in."
         #sign_in_and_redirect User.find(user.id) 
         return render 'oauth_popup_close', :layout => false            
       else
         session[:omniauth] = omni.except('extra')
         redirect_to new_user_registration_path
       end
     end 
   end
   
   def destroy
     @authentication = Authentication.find(params[:id])
     @authentication.destroy
     redirect_to authentications_url, :notice => "Successfully destroyed authentication."
   end
   
   
   def facebook
     #raise omni = request.env["omniauth.auth"].to_yaml

     omni = request.env["omniauth.auth"]
     authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

     if authentication
       #flash[:notice] = "Logged in Successfully"
       user = User.find(authentication.user_id)
       user.first_name = omni['extra']['raw_info'].first_name
       user.last_name = omni['extra']['raw_info'].last_name
       user.avatar_url = "http://graph.facebook.com/" + omni['uid'] + "/picture"

       user.save

       sign_in user
       return render 'oauth_popup_close', :layout => false            
     elsif current_user  && current_user.email == omni['extra']['raw_info'].email 

       token = omni['credentials'].token
       token_secret = ""

       current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)

       #flash[:notice] = "Authentication successful."
       sign_in current_user

       return render 'oauth_popup_close', :layout => false            

     else

       user = User.find_by_email(omni['extra']['raw_info'].email)

       if user 

        token = omni['credentials'].token
        token_secret = ""

        user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)

        sign_in user

        return render 'oauth_popup_close', :layout => false 

      end
      user = User.new
      user.email = omni['extra']['raw_info'].email 
      user.first_name = omni['extra']['raw_info'].first_name
      user.last_name = omni['extra']['raw_info'].last_name
      user.avatar_url = omni['info'].image

      user.apply_omniauth(omni)

      if user.save
       flash[:notice] = "Logged in."
       sign_in User.find(user.id)     

       return render 'oauth_popup_close', :layout => false            

     else
       session[:omniauth] = omni.except('extra')
       redirect_to new_user_registration_path
     end
   end
 end

  def check
    if current_user and auth = current_user.authentications.where(:provider => params[:provider]).first
      render :json => { :authed => true, :authentication => auth }
    elsif session[params[:provider] + "_omniauth_success"]
      # we set this session variable earlier - it lets us determine if an authenticaiton
      # has been successful
      session[params[:provider]] = nil
      render :json => { :authed => true }
    else
      render :json => { :authed => false }
    end
  end




end