class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    redirect_to :login unless User.find_by_provider_and_uid(auth["provider"], auth["uid"])
  end

end
