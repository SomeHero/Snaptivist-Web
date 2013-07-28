ActiveAdmin.register Petition do
  	index do
		selectable_column
		column :id
		column :title
		column :short_url
		column :subdomain
		column :created_at
		column :updated_at
		column :signatures_count

		default_actions
	end

	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs "Details" do
			f.input :user, :collection => User.where("organization_name is not null")
			f.input :target, :collection => Target.order("targetgroup_id").order("last_name").order("first_name").all
			f.input :subdomain
			f.input :target_count
			f.input :target_headline_text
			f.input :title
			f.input :call_to_action_button_text
			f.input :summary, :as => :text, :input_html => { :class => 'autogrow', :rows => 10, :cols => 20  }
			f.input :signature_comment_placeholder_text
			f.input :sign_with_facebook_cta_button_text
			f.input :sign_with_email_cta_button_text
			f.input :default_tweet_text, :as => :text, :input_html => { :class => 'autogrow', :rows => 10, :cols => 20 }
			f.input :header_image, :as => :file, :hint => f.template.image_tag(f.object.header_image.url(:medium))
    		f.input :comment
	end
	f.buttons
   end

end
