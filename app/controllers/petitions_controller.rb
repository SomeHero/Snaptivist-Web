class PetitionsController < InheritedResources::Base
	layout 'petitions'

	def view

		@petition = Petition.includes(:target).includes(:signatures)
		.find_by_subdomain(request.subdomain)

		raise "Unable to find petition" unless @petition

		render :show
	end

	def sign

	end
	
end
