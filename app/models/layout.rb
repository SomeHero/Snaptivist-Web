class Layout < ActiveRecord::Base
  attr_accessible :description, :name, :pages

  has_many :pages
  
    # generate the theme json
  def to_api

    results = {
      'layout_id' => id,
      'name' => name,
      'description' => description
    }

    return results;

  end

end
