class PetitionsController < InheritedResources::Base
	layout 'petitions'

	def view

		@petition = Petition.includes(:target).includes(:signatures)
		.find_by_rewrite_url_key(request.subdomain.gsub(".localhost", ""))

		raise "Unable to find petition" unless @petition

		render :show
	end

	def sign

	end
	
end
