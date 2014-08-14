class ApplicationController < ActionController::Base
  #protect_from_forgery

  def permitted_params
    @permitted_params ||= PermittedParams.new(params)
  end
  helper_method :permitted_params
  
  def authenticate
    redirect_to :login unless User.find_by_provider_and_uid(auth["provider"], auth["uid"])
  end

  def current_client
    @client ||= Client.find(session[:client_id]) if session[:client_id]
    #@user ||= User.find_by_session_token!(cookies[:session_token]) if cookies[:session_token]
    @client
  end
  helper_method :current_user

end
