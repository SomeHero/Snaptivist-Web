class Answer < ActiveRecord::Base
  #attr_accessible :choice_id, :poll_id
  belongs_to :choice
  belongs_to :poll
end
