ActiveAdmin.register PhoneCampaign do
    index do
		selectable_column
		column :id
		column :title
		column :short_url
		column :subdomain
		column :created_at
		column :updated_at
		column :call_results_count

		default_actions
	end

	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs "Details" do
			f.input :user, :collection => User.where("organization_name is not null")
			f.input :target, :collection => Target.order("targetgroup_id").order("last_name").order("first_name").all
			f.input :title
			f.input :summary
			f.input :subdomain
			f.input :target_count
			f.input :comment
			f.input :header_image, :as => :file, :hint => f.template.image_tag(f.object.header_image.url(:medium))

	end
	f.buttons
   end
end
