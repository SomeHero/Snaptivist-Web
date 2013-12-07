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

    #LOGIN to an existing treater account
  def render_response status: 200, obj: {}, notice: nil, url: root_path
    obj[:notice] = notice if obj.empty? && notice
    respond_to do |format|
      format.json { render json: obj.to_json, status: status }
      format.html { redirect_to url, notice: notice }
    end
  end

  def login
    binding.pry

    return render_response(status: 401, notice: 'Missing email address', url: request.original_url) unless params[:email]

    client = Client.find_by_email(params[:email])

    return render_response(status: 401, notice: 'Invalid email address or password', url: request.original_url) unless client

    if client && client.valid_password?(params[:password])
      session[:user_id] = user.id
      session[:client_url] = params[:on_complete_url]

      sign_in user

      result = {}
      result[:on_complete_url] = client_path(@client)
      render_response(obj: result, url: client_path(@client))

      return redirect_to client_path(@client) if client_admin?
    else
      render_response(status: 401, notice: 'Invalid email address or password', url: request.original_url)
    end

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
