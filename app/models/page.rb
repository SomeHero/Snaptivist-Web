class Page < ActiveRecord::Base
  belongs_to :layout
  attr_accessible :description, :name, :template_name, :url_fragment, :url_redirect, :url_redirect_property, :position

    # generate the theme json
  def to_api

    results = {
      'page_id' => id,
      'name' => name,
      'description' => description,
      'template_name' => template_name,
      'url_fragment' => url_fragment,
      'url_redirect' => url_redirect,
      'url_redirect_property' => url_redirect_property
     }
    return results;

  end

end
