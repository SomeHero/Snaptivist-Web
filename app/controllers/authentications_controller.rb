class AuthenticationsController < ApplicationController
  
  def index
    @authentications = current_user.authentications.all
  end
  
  def home
  end
  
  def twitter
    #raise omni = request.env["omniauth.auth"].to_yaml
     omni = request.env["omniauth.auth"]
     authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

     if authentication
       flash[:notice] = "Logged in Successfully"
       sign_in User.find(authentication.user_id)

       return render 'oauth_popup_close', :layout => false            
     elsif current_user
       token = omni['credentials'].token
       token_secret = omni['credentials'].secret

       current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
       flash[:notice] = "Authentication successful."
       sign_in current_user

       return render 'oauth_popup_close', :layout => false            
     
     else
       user = User.new 
       user.email = omni['info'].name
       user.apply_omniauth(omni)

       if user.save
         flash[:notice] = "Logged in."
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

       user.save

       sign_in user
       return render 'oauth_popup_close', :layout => false            
     elsif current_user
       token = omni['credentials'].token
       token_secret = ""

       current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)

       flash[:notice] = "Authentication successful."
       sign_in current_user

      return render 'oauth_popup_close', :layout => false            
     
     else
       user = User.new
       user.email = omni['extra']['raw_info'].email 
       user.first_name = omni['extra']['raw_info'].first_name
       user.last_name = omni['extra']['raw_info'].last_name

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
   
   
   
  
end