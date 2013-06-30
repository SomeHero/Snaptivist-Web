class PetitionsController < InheritedResources::Base
	layout 'petitions'

	def view

		@petition = Petition.includes(:target).includes(:signatures)
		.find_by_rewrite_url_key(request.subdomain.gsub(".localhost", ""))

		render :show
	end

	def sign

	end
	
end
