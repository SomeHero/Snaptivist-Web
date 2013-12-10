class ClientsController < ApplicationController
  respond_to :json, :html

  #caches_action :show, :cache_path => :show_cache_path.to_proc, :expires_in => 10.seconds
  before_filter :get_client, only: [:show, :login, :confirm]
  before_filter :require_current_client_user!, only: [:show]

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
    @on_complete_url = client_path(@client)
    @on_fail_url = request.original_url

    return redirect_to root_path if current_user && !(client_admin?)
    return redirect_to client_path(@client) if client_admin?
  end

  def validate

    return render_response(status: 401, notice: 'Missing email address', url: login_client_path) unless params[:email]

    client = Client.find_by_email(params[:email])

    return render_response(status: 401, notice: 'Invalid email address or password', url: login_client_path) unless client

    if client && client.valid_password?(params[:password])
      session[:client_id] = client.id
      session[:client_url] = params[:on_complete_url]

      #sign_in user

      result = {}
      result[:on_complete_url] = client_path(client)
      render_response(obj: result, url: client_path(client))

      #return redirect_to client_path(client)
    else
      render_response(status: 401, notice: 'Invalid email address or password', url: login_client_path)
    end

  end

private
  def get_client
    @client ||= Client.find params[:id]
    return redirect_to(root_url) unless @client
  end

  def client_admin?
    session["client_id"]
  end

  def require_current_client_user!
    redirect_to login_client_path(@client) unless client_admin?
  end
end
