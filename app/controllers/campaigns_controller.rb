class CampaignsController < InheritedResources::Base

	def view

		@petition = Campaign.includes(:campaign_pages)
			.find(params[:id])
		
		@campaign = Rabl::Renderer.json(@petition, 'campaigns', :view_path => 'app/views/api')
 
		render :show
	end

	def sign

	end

	def actions

	end
	
end
