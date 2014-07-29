class PollResponse < ActiveRecord::Base
  belongs_to :poll
  belongs_to :choice
  #attr_accessible :comment
end
