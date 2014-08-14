class PollsController < InheritedResources::Base
	layout 'actions'

	def view
		@poll = Poll.find_by_rewrite_url_key(params[:action_title])

		render :show
	end

	 def params
    	params.permit(:label, :position, :poll_choices)
  	end
end
