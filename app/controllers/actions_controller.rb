class ActionsController < InheritedResources::Base

	def view

		subdomain = request.subdomain
		subdomain.slice! "www."
		
		@petition = Petition.includes(:target).includes(:signatures)
		.find_by_subdomain(:first, :conditions => [ "lower(subdomain) = ?", subdomain.downcase ])

		@phonecampaign = PhoneCampaign.includes(:target).includes(:call_results)
		.find_by_subdomain(:fist, :conditions => [ "lower(subdomain) = ?", subdomain.downcase ])

		@poll = Poll.includes(:choices)
		.find_by_subdomain(:first, :conditions => [ "lower(subdomain) = ?", subdomain.downcase ])

		if params[:signature_id]
			@signature = Signature.find_by_id(params[:signature_id])
		end
		
		if @petition
			render 'petitions/show', :layout => 'petitions' 
		elsif @phonecampaign
			render 'phonecampaigns/show', :layout => 'phonecampaigns'
		elsif @poll
			render 'polls/show', :layout => 'polls'
		else
			raise "No action found; not sure what to do"
		end




	end

	def sign

	end
	
end