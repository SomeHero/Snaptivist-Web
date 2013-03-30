class PhonecampaignsController < InheritedResources::Base
	layout 'actions'

	def view
		@phonecampaign = PhoneCampaign.find_by_rewrite_url_key(params[:action_title])

		render :show
	end
end
