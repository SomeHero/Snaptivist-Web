class HomeController < ApplicationController

  def index
  	Rails.logger.debug request.headers["HTTP_USER_AGENT"]
  end

  private

end
