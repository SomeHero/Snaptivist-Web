class Theme < ActiveRecord::Base
  belongs_to :layout
  attr_accessible :layout, :css_file, :description, :name, :url_fragment

  # generate the theme json
  def to_api

    results = {
      'theme_id' => id,
      'name' => name,
      'description' => description,
      'css_file' => css_file,
      'url_fragment' => url_fragment
    }

    return results;

  end
  

end
