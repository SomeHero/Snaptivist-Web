ActiveAdmin.register Petition do
  	index do
		selectable_column
		column :id
		column :title
		column :short_url
		column :rewrite_url_key
		column :created_at
		column :updated_at
		column :signatures_count

		default_actions
	end

	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs "Details" do
			f.input :user
			f.input :target
			f.input :title
			f.input :summary
			f.input :subdomain
			f.input :target_count
			f.input :header_image, :as => :file, :hint => f.template.image_tag(f.object.header_image.url(:medium))
    
	end
	f.buttons
   end

end
