class UserCampaignAction < ActiveRecord::Base	
  belongs_to :user
  belongs_to :campaign
  belongs_to :action
  attr_accessible :user, :campaign, :action, :type
end
