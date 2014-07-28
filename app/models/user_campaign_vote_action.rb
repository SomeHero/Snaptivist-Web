class UserCampaignVoteAction < UserCampaignAction
  belongs_to :poll_choice
  attr_accessible :reason, :poll_choice
end
