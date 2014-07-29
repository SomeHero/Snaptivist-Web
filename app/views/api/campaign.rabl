object @campaign
attributes :id, 
  :title,
  :subdomain
  :created_at
  :updated_at
child :layout => :layout do
  attributes :id, 
    :name, 
    :url_fragment,
    :description  
end
child :theme => :theme do
  attributes :id, 
    :name, 
    :description,
    :css_file,
    :url_fragment
end
child :campaign_pages do |campaign_page|
  attributes :id,
    :position
    node :content do |cp| 
      cp.content
    end
    node :action do |cp|
      cp.get_action()
    end
  child :page do |page|
    attributes :id,
    :name, 
    :description,
    :template_name,
    :url_fragment,
    :url_redirect,
    :url_redirect_property
  end
end
child :email_configurations do |email_configuration|
  attributes :email_type_id,
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