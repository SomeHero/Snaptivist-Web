
class AuthsController < ApplicationController
  respond_to :json, :html
  #Authentication callback for Janrain
  def callback
    rpx_auth
    after_auth(params[:on_complete_url])
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
    return render_response(status: 401, notice: 'Missing email address', url: params[:on_fail_url]) unless params[:email]

    user = AdminUser.find_by_email(params[:email])

    return render_response(status: 401, notice: 'Invalid email address or password', url: params[:on_fail_url]) unless user

    if user && user.valid_password?(params[:password])
      session[:user_id] = user.id
      session[:client_url] = params[:on_complete_url]

      sign_in user

      result = {}
      result[:on_complete_url] = params[:on_complete_url]
      render_response(obj: result, url: params[:on_complete_url])

    else
      render_response(status: 401, notice: 'Invalid email address or password', url: params[:on_fail_url])
    end
  end

  #CREATE a new user account
  def register
    return render :json => 'Invalid email address or password', status: 401 unless params[:email_address]
    existing_treater_account = TreaterAccount.find_by_email_address(params[:email])
    existing_user = existing_treater_account ? existing_treater_account.user : nil

    if existing_user.nil? && existing_treater_account.nil?
      #TODO - Fix attr_accessible white list so we dont' have to build this manually...
      user = User.create(email_address: params[:email], name: params[:name],
                     password: params[:password], password_confirmation: params[:password_confirmation])
      treater_account = TreaterAccount.create(user_id: user.id, identifier: user.id, name: params[:name], email: user.email_address, authenticated_at: Time.now)
      user.account_setup

      session[:user_id] = user.id
      session[:external_account_id] = treater_account.id

      result = {}
      result[:on_complete_url] = params[:on_complete_url]
      return render :json => result.to_json, status: 200
    elsif existing_user && existing_treater_account.nil?
      #TODO - Fix attr_accessible white list so we dont' have to build this manually...
      #     - Move all this logic to account_setup
      treater_account = TreaterAccount.create(user_id: existing_user.id, identifier: existing_user.id, name: params[:name], email: existing_user.email_address, authenticated_at: Time.now)

      session[:user_id] = existing_user.id
      session[:external_account_id] = treater_account.id

      result = {}
      result[:on_complete_url] = params[:on_complete_url]
      return render :json => result.to_json, status: 200
    else
      #login failed
      return render :json => 'Some error...', status: 401
    end
  end

  def logout
    on_complete_url = session[:client_url]
    clear_user_session

    after_auth(on_complete_url)
  end

  private

  def rpx_auth
    rpx = Rpx::RpxHelper.new(ENV['RPX_API_KEY'],Settings.rpx_auth_url,"")
    rpx_data = rpx.auth_info(params['token'])
    ap rpx_data

    raise 'rpx_invalid' unless rpx_data['profile']

    #Sign-in existing user
    if @external_account = ExternalAccount.from_rpx(rpx_data)
      #Map user account in janrain
      rpx.map(@external_account.rpx_identifier, @external_account.user.id)

      #Don't login the user if they're banned
      # TODO: Re-implement this when we are ready to have user auth validations
      #unless @external_account.user.valid_for_authentication?
        #clear_user_session
        #redirect_to root_path && return
      #end

      #Setup user session
      session[:user_id] = @external_account.user.id
      session[:external_account_id] = @external_account.id
    end
  end

  def clear_user_session

    cookies.delete(:session_token)
    session[:user_id] = nil
    session[:client_id] = nil
    session[:external_account_id] = nil
    session[:admin_logged_in] = nil
    @user = nil
    @client = nil
  end

  def after_auth(on_complete_url)
    redirect_to(on_complete_url || root_path) && return
  end

end
