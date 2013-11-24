class ClientsController < ApplicationController
  respond_to :json, :html

  #caches_action :show, :cache_path => :show_cache_path.to_proc, :expires_in => 10.seconds
  before_filter :get_client, only: [:show, :login, :confirm]
  before_filter :require_current_merchant_user!, only: [:show]

  layout 'clients'

  def show
    @client_data = @client.to_api
    @current_client = current_client
  end

  def login

    @on_complete_url = client_path(@client)
    @on_fail_url = request.original_url

    return redirect_to client_path(@client) if client_admin?
  end

private
  def get_client
    @client ||= Client.find params[:id]
    return redirect_to(root_url) unless @client
  end

  def client_admin?
    current_client
  end

  def require_current_merchant_user!
    redirect_to login_client_path(@client) unless client_admin?
  end
end
