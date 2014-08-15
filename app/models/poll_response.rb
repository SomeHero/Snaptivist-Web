class PollResponse < ActionResponse
  belongs_to :poll
  belongs_to :poll_choice
  #attr_accessible :comment
end
