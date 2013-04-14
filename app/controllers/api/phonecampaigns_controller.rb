class Api::PhonecampaignsController < ApplicationController
  #before_filter :authenticate_user!, :only => [:create]

  respond_to :json

  API_VERSION = '1.0'
 
  def create

    #auth_mechanism = params.fetch(:auth_mechanism, 'standard')
    @phone_campaign = PhoneCampaign.new do |p|
    	p.title = params[:title]
    	p.summary = params[:summary]
    	p.target_count =100
      p.target_id = params[:target_id]
      p.rewrite_url_key = params[:title].gsub(" ", "-")
    end

    if !@phone_campaign.valid?
     return render_result({}, 400, @phone_campaign.errors)
    end

    #return if error_messages?(:config)

    @phone_campaign.save
    

    @phone_campaign.short_url = @phone_campaign.shorten_url

    @phone_campaign.save!
    
    render_result(@phone_campaign.to_api)

  end

  def share

    #handle to tweating here

  end

  def log

  end

  def show
    @phone_campaign = PhoneCampaign.find(params[:id])

    raise Error404 unless @phone_campaign

    render_result(@phone_campaign.to_api)
  end

	# render a result in the appropriate format
	def render_result(result = {}, status = 200, status_string = 'OK')
		return_value = {'version' => API_VERSION,
			'statusCode' => status,
			'statusString' => status_string,
			'result' => result}
			if params[:callback]
				render :text => "#{params[:callback]}(#{return_value.to_json});", :content_type => "application/javascript"
			elsif params[:isIEPhoto]
				render :text=> return_value.to_json, :content_type => "text/plain"
			else
				render :json => return_value.to_json
			end
		end

	end