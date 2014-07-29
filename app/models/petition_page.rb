class PetitionPage < ActiveRecord::Base
  belongs_to :petition
  belongs_to :page
  #attr_accessible :petition, :page, :page_id, :position

    # generate the theme json
  def to_api

    results = {
      'page_id' => id,
      'position' => position,
      'page' =>  page ? page.to_api : nil
     }
    return results;

  end

end
