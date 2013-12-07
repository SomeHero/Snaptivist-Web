class ApplicationController < ActionController::Base
  #protect_from_forgery

  def authenticate
    redirect_to :login unless User.find_by_provider_and_uid(auth["provider"], auth["uid"])
  end

  def current_client
    @user ||= User.find(session[:user_id]) if session[:user_id]
    #@user ||= User.find_by_session_token!(cookies[:session_token]) if cookies[:session_token]
    @user
  end
  helper_method :current_user

  def sync_crm

    #now add the new user to configured CRM
    Rails.logger.debug "Syncing new user to CRM"

    crm = CrmNotification::NationBuilderCrmNotifier.new
    result = crm.create_or_update_supporter(@petition.client.nation_builder_crm_authentication, current_user)

    if result
      current_user.external_id = result.id
      current_user.save!
    end

  end


end
