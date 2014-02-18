class Clients::PetitionsController < ApplicationController
  respond_to :json, :html

  before_filter :get_client
  before_filter :require_current_client_user!

  layout 'clients'

  def index
  	@petitions = Petition.all
  	@client_data = @client.to_api
    @current_client = current_client
  end

  def show
  	@client_data = @client.to_api
    @current_client = current_client
    @petition = Petition.find(params[:id])
    @content = REDIS.get("action-"+ @petition.id.to_s)
  end

  private
	 def get_client
	   @client ||= Client.find params[:client_id]
	   return redirect_to(root_url) unless @client
	 end

	def client_admin?
	   session["client_id"]
	end

	def require_current_client_user!
	  redirect_to login_client_path(@client) unless client_admin?
	end
 end
