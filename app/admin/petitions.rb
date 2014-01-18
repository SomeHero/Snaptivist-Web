	ActiveAdmin.register Petition do
  	config.filters = false

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
			f.input :layout, :collection => Layout.all
			f.input :theme, :collection => Theme.all
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
		f.inputs "Email Configurations" do 
			f.has_many :email_configurations, :allow_destroy => false, :heading => false, :new_record => false do |email_config|
		      email_config.input :email_type
		      email_config.input :from_name
		      email_config.input :from_address
		      email_config.input :subject
		      email_config.input :email_template
		      email_config.input :enabled
		      #repeat as necessary for all fields
			end
		end
	f.buttons
   end

end
