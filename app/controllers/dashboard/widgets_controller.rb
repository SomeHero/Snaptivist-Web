class Dashboard::WidgetsController < ApplicationController

  def index
  	Rails.logger.debug request.headers["HTTP_USER_AGENT"]
  end

  def show

  end

  private

end
