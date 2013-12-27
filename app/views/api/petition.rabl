object @petition
attributes :id, 
  :name,
  :target_headline_text,
  :action_tags,
  :title,
  :headline_primary,
  :headline_secondary,
  :subheadline,
  :call_to_action_button_text,
  :summary,
  :signature_headline_primary,
  :signature_headline_secondary,
  :signature_comment_placeholder_text,
  :sign_with_facebook_cta_button_text,
  :sign_with_email_cta_button_text,
  :signature_more_signers_button_text,
  :delivery_headline_primary,
  :delivery_headline_secondary,
  :delivery_subheadline,
  :delivery_call_to_action_text,
  :delivery_call_to_action_button_text,
  :delivery_skip_button_text,
  :delivery_more_tweets_button_text,
  :delivery_more_tweets_button_text,
  :premium_headline_primary,
  :premium_headline_secondary,
  :premium_subheadline,
  :premium_call_to_action_text,
  :premium_call_to_action_button_text,
  :premium_skip_button_text,
  :default_tweet_text,
  :tweet_cta_button_text,
  :signatures_count,
  :target_count,
  :short_url,
  :subdomain,
  :donation_page_url,
  :image_thumb_url,
  :image_square_url,
  :image_medium_url,
  :image_full_url,
  :disclaimer_text,
  :created_at,
  :updated_at

  node :share_count do |petition|
    petition.share_count
  end
  node :delivery_count do |petition|
    petition.delivery_count
  end
  node :image_full_url do |petition|
    petition.petition_image_url
  end

  child :email_configurations => :email_configurations_attributes do
    attributes :id,
    :email_type_id,
    :subject,
    :from_name,
    :from_address,
    :enabled
    child :email_type do
      attributes :id,
      :name,
      :description
    end
  end
  child :layout do
    attributes :id, 
      :name, 
      :url_fragment,
      :description  
  end
  child :theme do
    attributes :id, 
      :name, 
      :description,
      :css_file,
      :url_fragment
  end
  child :petition_pages => :petition_pages_attributes do
    attributes :id, 
    :page_id, 
    :position
  end
  child :pages do
    attributes :id, 
    :name, 
    :description,
    :template_name,
    :url_fragment,
    :url_redirect,
    :url_redirect_property
  end




