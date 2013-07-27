ActiveAdmin.register Poll do
index do
	selectable_column
	column :question
	column 'Choices' do |poll|
		poll.choices.map { |choice|
			link_to choice.choice, admin_choice_path(choice)
			}.join("<br/>").html_safe
		end
	column :subdomain
	column :short_url

	 default_actions

	end

	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs "Details" do
		f.input :user, :collection => User.where("organization_name is not null")
		f.input :question
		f.input :subdomain
		f.input :header_image, :as => :file, :hint => f.template.image_tag(f.object.header_image.url(:medium))
		f.input :comment
	end
	f.buttons
   end

end
