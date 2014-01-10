require "uri"
require "net/http"

class OauthController < ApplicationController

  def nation_builder
  	
  	Rails.logger.debug request.params[:code]

  	client = Client.find(session["client_id"])

  	raise "Invalid client" unless client

  	params = {
  		'client_id' => session['client_app_id'],
		'redirect_uri' => session['redirect_uri'],
		'grant_type'=>'authorization_code',
		'client_secret'=> session['client_secret'],
		'code'=>request.params[:code]
	}

	response = Net::HTTP.post_form(URI.parse('https://' + session['nation_name'] + '.nationbuilder.com/oauth/token'), params)

	jsonObject = JSON.parse response.body
	access_token = jsonObject['access_token']

	NationBuilderCrmAuthentication.create!(
		client: client,
		nation_name: session['nation_name'],
		client_app_id: session['client_app_id'],
		client_secret: session['client_secret'],
		access_token: access_token,
		redirect_uri: session['redirect_uri']
	)
	
	return render 'oauth_popup_close', :layout => false 

  end


  private

end
