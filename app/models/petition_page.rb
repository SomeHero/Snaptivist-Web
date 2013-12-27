class PetitionPage < ActiveRecord::Base
  belongs_to :petition
  belongs_to :page
  attr_accessible :petition, :page, :page_id, :position

end
