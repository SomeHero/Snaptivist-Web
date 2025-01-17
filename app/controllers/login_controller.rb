class LoginController < ApplicationController
  helper DeviseHelper
  layout "clients"

  def new
    @user = User.new
  end

  def create

    client_user =ClientUser.joins(:user)
      .where("users.email" => params[:email])
      .first

    if client_user.nil?
      flash.now[:error] = "Invalid email/password combination."
      render action: "new"
    else
      user = client_user.user

      if user.nil?
        flash.now[:error] = "Invalid email/password combination."
        render action: "new"
      else
        if user.valid_password?(params[:password]) 
          @client = Client.find(client_user.client)
          session["client_id"] = @client.id
        
          sign_in user

          redirect_to client_campaigns_url(@client)
        else
          flash.now[:error] = "Invalid email/password combination."
          render action: "new"
        end
      end
    end

  end
end
