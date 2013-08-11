class Dashboard::ClientsController < ApplicationController

  def index
  	Rails.logger.debug request.headers["HTTP_USER_AGENT"]

  	@petitions = Petition.all

 
  end

  def show

  end

  private

end
