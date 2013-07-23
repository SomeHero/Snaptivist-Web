ActiveAdmin.register User do
    index do
		selectable_column
		column :id
		column :email
		column :first_name
		column :last_name
		column :organization_name
		column :zip_code
		column :created_at

		default_actions
	end

	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs "Details" do
			f.input :email
			if f.object.new_record?
	            f.input :password
	            f.input :password_confirmation
	        end
			f.input :first_name
			f.input :last_name
			f.input :organization_name
			f.input :organization_avatar, :as => :file, :hint => f.template.image_tag(f.object.organization_avatar.url(:medium))
			f.input :zip_code
    
	end
	f.buttons
   end
end
