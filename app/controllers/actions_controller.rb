class ActionsController < InheritedResources::Base

	def view

		@petition = Petition.includes(:target).includes(:signatures)
		.find_by_subdomain(request.subdomain)

		@phonecampaign = PhoneCampaign.includes(:target).includes(:call_results)
		.find_by_subdomain(request.subdomain)

		@poll = Poll.includes(:choices)
		.find_by_subdomain(request.subdomain)

		if @petition
			render 'petitions/show', :layout => 'petitions' 
		elsif @phonecampaign
			render 'phonecampaigns/show', :layout => 'phonecampaigns'
		elsif @poll
			render 'polls/show'
		else
			raise "No action found; not sure what to do"
		end




	end

	def sign

	end
	
end