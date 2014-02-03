class PetitionConditionalActionTag < ActiveRecord::Base
  belongs_to :petition
  belongs_to :conditional_action_type_type
  attr_accessible :action_tags
end
