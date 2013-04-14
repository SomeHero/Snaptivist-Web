class PetitionsController < InheritedResources::Base
	layout 'actions'

	def view
		@petition = Petition.includes(:target).includes(:signatures)
		.find_by_rewrite_url_key(params[:action_title])

		render :show
	end

	def sign

	end
	
end
