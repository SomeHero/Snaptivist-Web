class Clients::CampaignsController < ApplicationController
  respond_to :json, :html

  before_filter :get_client
  before_filter :require_current_client_user!

  layout 'clients/campaigns'

  def index
  	@campaigns = @client.campaigns.all
  	@client_data = @client.to_api
    @current_client = current_client
  end

  def show
  	@client_data = @client.to_api
    @current_client = current_client
    @campaign = Campaign.find(params[:id])
    #@content = REDIS.get("action-"+ @petition.id.to_s)
  end

  def actions

  end
  
  private
	 def get_client
     return redirect_to(root_url) unless session[:client_id]

     @client ||= Client.find session[:client_id]
	   return redirect_to(root_url) unless @client
	 end

	def client_admin?
    session["client_id"]
	end

	def require_current_client_user!
	  redirect_to login_client_path(@client) unless client_admin?
	end
 end
