class Layout < ActiveRecord::Base
  attr_accessible :description, :name, :pages, :url_fragment

  has_many :pages
  
    # generate the theme json
  def to_api

    results = {
      'layout_id' => id,
      'name' => name,
      'url_fragment' => url_fragment,
      'description' => description
    }

    return results;

  end

end
