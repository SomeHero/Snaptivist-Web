class SignupController < ApplicationController
  helper DeviseHelper
  layout "clients"
  
  def new
    @client = Client.new
    @user = @client.admin_users.build
  end

  def create

    @client = Client.new params[:client]
    @user = @client.admin_users.first

    if @client.save
      session["client_id"] = @client.id
    
      sign_in @user

      redirect_to client_campaigns_url(@client)
    else
      @user = @client.admin_users.first
      render :new
    end
  end
end
