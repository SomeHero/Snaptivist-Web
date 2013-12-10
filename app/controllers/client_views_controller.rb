class ClientViewsController < ApplicationController
  protect_from_forgery
  # do not use CSRF for CORS options
  skip_before_filter :verify_authenticity_token, :only => [:options]

  before_filter :cors_set_access_control_headers
  before_filter :authenticate_cors_user

  def authenticate_cors_user
    if request.xhr? && !user_signed_in?
      error = { :error => "You must be logged in." }
      render :json => error, :status => 401
    end
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*, X-Requested-With, X-Prototype-Version, X-CSRF-Token, Content-Type'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def options 
    render :text => '', :content_type => 'text/plain'
  end
	
	def show 
		render params[:id], layout: nil 
	end
end