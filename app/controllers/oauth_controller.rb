class OauthController < ApplicationController

  def nation_builder
  	binding.pry
  	Rails.logger.debug request.params[:code]
  end

  private

end
