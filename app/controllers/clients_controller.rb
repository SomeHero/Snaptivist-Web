class ClientsController < ApplicationController
  respond_to :json, :html

  #caches_action :show, :cache_path => :show_cache_path.to_proc, :expires_in => 10.seconds
  before_filter :get_client, only: [:show, :login, :confirm]

  layout 'clients'

  def show
    @client_data = @client.to_api
  end

private
  def get_client
    @client ||= Client.find params[:id]
    return redirect_to(root_url) unless @client
  end

  def client_admin?
    current_user
  end
end
