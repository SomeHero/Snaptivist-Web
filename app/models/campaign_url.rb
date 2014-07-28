class CampaignUrl < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :url
  # attr_accessible :title, :body
end
