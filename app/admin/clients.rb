ActiveAdmin.register Client do
	config.filters = false
	
  	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs "Details" do
			f.input :user
			f.input :name
			f.input :avatar, :as => :file, :hint => f.template.image_tag(f.object.avatar.url(:medium))
    
		end
		
		f.buttons

   	end
end
