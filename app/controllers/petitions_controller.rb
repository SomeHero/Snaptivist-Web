class PetitionsController < InheritedResources::Base
	layout 'actions'

	def view
		@petition = Petition.includes('target').find_by_rewrite_url_key(params[:action_title])

		render :show
	end
end
