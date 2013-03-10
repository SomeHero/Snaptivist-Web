class Api::PetitionsController < ApplicationController
  #before_filter :authenticate_user!, :only => [:create]
  after_filter :set_access_control_headers

  respond_to :json

  API_VERSION = '1.0'

  def set_access_control_headers
     headers['Access-Control-Allow-Origin'] = '*'
     headers['Access-Control-Request-Method'] = '*'
  end
  
  def create

    #auth_mechanism = params.fetch(:auth_mechanism, 'standard')
    @petition = Petition.new do |p|
    	p.title = params[:title]
    	p.summary = params[:summary]
    	p.target_count =100
        p.target_id = 1
  	end

  if !@petition.valid?
  	return render_result({}, 400, 'Error Creating Petition')
  end

    #return if error_messages?(:config)

    @petition.save
    
    render_result({'petition' => {'id' => @petition.id,
                                  'title' => @petition.title,
                                  'summary' => @petition.summary
                                  }})

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