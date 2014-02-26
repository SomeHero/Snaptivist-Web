class HomeController < ApplicationController
	layout 'home'

  def index
  	Rails.logger.debug request.headers["HTTP_USER_AGENT"]
  end

  private

end
