class ConditionalActionTag < ActiveRecord::Base
  belongs_to :petition
  belongs_to :conditional_action_tag_type
  #attr_accessible :petition, :conditional_action_tag_type, :conditional_action_tag_type_id, :action_tags
end
