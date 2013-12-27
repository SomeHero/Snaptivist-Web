ActiveAdmin.register Layout do
  menu :parent => "Settings"

  form :html => { :enctype => "multipart/form-data" } do |f|
	f.inputs "Details" do
		f.input :name
		f.input :description
		f.input :url_fragment
	end
	f.inputs "Themes" do 
		f.has_many :themes, :allow_destroy => true, :heading => false, :new_record => true do |theme|
	      theme.input :name
	      theme.input :description
	      theme.input :url_fragment
	      theme.input :css_file
	      #repeat as necessary for all fields
		end
	end
	f.inputs "Pages" do 
		f.has_many :pages, :allow_destroy => true, :heading => false, :new_record => true do |theme|
	      theme.input :name
	      theme.input :description
	      theme.input :template_name
	      theme.input :url_fragment
	      theme.input :url_redirect
	      theme.input :url_redirect_property

		end
	end

	f.buttons
   end
end
