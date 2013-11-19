class PetitionsController < InheritedResources::Base
	layout 'petitions'

	def view

		if params[:action_title].to_i != 0
			@petition = Petition.includes(:target).includes(:signatures).find(params[:action_title].to_i)
		else
			@petition = Petition.includes(:target).includes(:signatures)
			.find_by_subdomain(request.subdomain)
		end

		raise "Unable to find petition" unless @petition

		render :show
	end

	def sign

	end
	
end
