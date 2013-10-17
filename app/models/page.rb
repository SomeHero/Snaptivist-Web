class Page < ActiveRecord::Base
  belongs_to :layout
  attr_accessible :description, :name, :template_name

    # generate the theme json
  def to_api

    results = {
      'page_id' => id,
      'name' => name,
      'description' => description,
      'template_name' => template_name
    }

    return results;

  end

end
