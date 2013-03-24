class Api::TargetsController < ApplicationController
  #before_filter :authenticate_user!, :only => [:create]

  respond_to :json

  API_VERSION = '1.0'

  def index

  	if(params[:state] && params[:targetgroup_id])
  		targets = Target.where("targetgroup_id = ? AND state = ?", params[:targetgroup_id], params[:state])
  	elsif(params[:targetgroup_id])
  		targets = Target.find_all_by_targetgroup_id(params[:targetgroup_id])
  	else
		targets = Target.all
	end

	results = []
	targets.each do |target|
        results << target.to_api
    end

	render_result(results)

  end

  def show
    @target = Target.find(params[:id])
    raise Error404 unless @target

    render_result(@target.to_api)
  end

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