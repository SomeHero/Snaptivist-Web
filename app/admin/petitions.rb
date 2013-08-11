	ActiveAdmin.register Petition do
  	index do
		selectable_column
		column :id
		column :client
		column :title
		column :short_url
		column :subdomain
		column :signatures_count
		column("Share Count") { |petition| petition.signatures.limit(nil).where("shared = true").count }
		column("Delivery Count") { |petition| petition.signatures.limit(nil).where("delivered = true").count }
		column :active
		default_actions
	end

	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs "Details" do
			f.input :client
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
			f.input :tweet_cta_button_text
			f.input :header_image, :as => :file, :hint => f.template.image_tag(f.object.header_image.url(:medium))
    		f.input :action_tags
    		f.input :comment
    		f.input :active
	end
	f.buttons
   end

end
