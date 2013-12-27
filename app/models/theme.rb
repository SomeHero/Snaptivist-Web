class Theme < ActiveRecord::Base
  attr_accessible :css_file, :description, :name

  # generate the theme json
  def to_api

    results = {
      'theme_id' => id,
      'name' => name,
      'description' => description,
      'css_file' => css_file
    }

    return results;

  end
  

end
