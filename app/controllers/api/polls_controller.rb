class Api::PollsController < ApplicationController
  #before_filter :authenticate_user!, :only => [:create]

  respond_to :json

  API_VERSION = '1.0'
 
  def create

    poll = params[:poll]

   @choices = []
   poll[:choices].each do |attributes|
      @choices << Choice.new(attributes)
   end

    #auth_mechanism = params.fetch(:auth_mechanism, 'standard')
    @poll = Poll.new do |p|
    	p.question = poll[:question]
      p.rewrite_url_key = poll[:question].gsub(" ", "-")
      p.choices = @choices
    end

    if !@poll.valid?
     return render_result({}, 400, @polll.errors)
    end

    #return if error_messages?(:config)

    @poll.save

    @poll.short_url = @poll.shorten_url

    @poll.save!
    
    
    render_result(@poll.to_api)

  end

  def launch

    #update action to launched
    
  end

  def share

    #handle to tweating here

  end
  
  def show
    @poll = Poll.find(params[:id])

    raise Error404 unless @poll

    render_result(@poll.to_api)
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