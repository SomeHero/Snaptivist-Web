class PetitionsController < InheritedResources::Base
	layout 'actions'

	def view
		@petition = Petition.includes(:target)
			.find_by_rewrite_url_key(params[:action_title])

		@petition.signatures = Signature.limit(10)
			.order("created_at desc")
			.where(:petition_id => @petition.id)
			
		render :show
	end

	def sign

	end
	
end
