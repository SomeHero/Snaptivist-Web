class Dashboard::ClientsController < ApplicationController
  before_filter :authenticate_client!

  def index
  	Rails.logger.debug request.headers["HTTP_USER_AGENT"]


  	@client = Client.where(:id => 3)

  	@petitions = Petition.where(:client_id => 3)

  	@stats = {}

  	@stats[:active_campaigns] = @petitions.count
  	@stats[:signatures] = Signature.joins(:petition).where(petitions: {client_id: 3}).count
  	@stats[:deliveries] = Signature.joins(:petition).where(signatures: {delivered: true}, petitions: {client_id: 3}).count
  	@stats[:shares] = Signature.joins(:petition).where(signatures: {shared: true}, petitions: {client_id: 3}).count
 
  end

  def show

  end

  private

  def authenticate_user
  	return true;
  end

end
