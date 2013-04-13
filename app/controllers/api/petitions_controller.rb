
class Api::PetitionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :share]

  respond_to :json

  API_VERSION = '1.0'

 def create

    #auth_mechanism = params.fetch(:auth_mechanism, 'standard')
    @petition = Petition.new do |p|
      p.user = current_user
    	p.title = params[:title]
    	p.summary = params[:summary]
    	p.target_count =100
      p.signatures_count = 0
      p.target_id = params[:target_id]
      p.rewrite_url_key = params[:title].gsub(" ", "-")
    end

    if !@petition.valid?
     return render_result({}, 400, @petition.errors)
   end

    #return if error_messages?(:config)

    @petition.save

    @petition.short_url = @petition.shorten_url

    @petition.save!
    
    render_result(@petition.to_api)

  end

  def launch

    #update action to launched
    
  end

  def share

    #handle to tweating here
    #if params[:tweet]
    token = current_user.authentications.find_by_provider("twitter").token
    token_secret = current_user.authentications.find_by_provider("twitter").token_secret

    Twitter.configure do |config|
      config.consumer_key = 'JRkoDk6R3BxPpmu5sIsKLA'
      config.consumer_secret = 'AUApr8ShZz9qGT0Xfsq6GKruD0rxunZGUCJUs0wXmo'
      config.oauth_token = token
     config.oauth_token_secret = token_secret

    Twitter.update(params[:tweet])

    render_result()

    end
  end

  def sign

      @petition = Petition.find(params[:id]);

      raise "Unable to find petition" unless @petition

      signature = @petition.signatures.new do |s|
        s.user = current_user
        s.comment = params[:comment]
      end


    if !signature.valid?
     return render_result({}, 400, 'Error Signing Petition')
    end

    #return if error_messages?(:config)
    @petition.save

    render_result(@petition.to_api)
  end

  def show
    @petition = Petition.find(params[:id])

    raise Error404 unless @petition

    render_result(@petition.to_api)
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