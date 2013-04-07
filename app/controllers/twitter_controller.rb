require 'twitter_oauth'

class TwitterController < ApplicationController

  skip_before_filter :login_required

  before_filter :link_client

  def destroy
    begin
      current_user.twitter_token = nil
      current_user.twitter_secret = nil
      raise 'Could not save user' if !current_user.save
      flash[:notice] = 'Your have revoked your Twitter account authorization'
    rescue
      flash[:error] = 'Could not revoke your Twitter account authorization'
    end

    redirect_to(edit_user_path(current_user))
  end  

  # authorize oauth client and save access keys
  def new  

    Rails.logger.debug "Beginning authorize oauth client and access key process process for Twitter" 
        
    begin
      if params[:oauth_token] != session['oauth_request_token_token']
        flash[:error] = 'Could not authorize your Twitter account'
        return redirect_to(edit_user_path(current_user))
      end

      oauth_token = session['oauth_request_token_token']
      oauth_secret = session['oauth_request_token_secret']

      # if we're here, save the tokens to user
      access_token = @client.authorize(
        oauth_token,
        oauth_secret
      )

      if @client.authorized?
        client_info = @client.info

        current_user.twitter_token = access_token.token
        current_user.twitter_secret = access_token.secret
        raise 'Could not save user' if !current_user.save
      end

      session['oauth_request_token_token'] = nil
      session['oauth_request_token_secret'] = nil
      flash[:notice] = 'Your account has been authorized at Twitter'
    rescue
      flash[:error] = 'There was an error during processing the response from Twitter.'
    end

    return render 'popup_close', :layout => false

  end

  # start a request and send to twitter
  def create
    request_token = @client.request_token( :oauth_callback => "http://localhost:3000/twitter/new" ) 
    
    session['oauth_request_token_token'] = request_token.token
    session['oauth_request_token_secret'] = request_token.secret

    redirect_to request_token.authorize_url
  end

  private

    def link_client
      @client = TwitterOAuth::Client.new(
          :consumer_key => TWITTER_CONSUMER_KEY,
          :consumer_secret => TWITTER_CONSUMER_SECRET
      )
    end

end