class CampaignPageUrl < ActiveRecord::Base
  belongs_to :campaign_page
  belongs_to :url
  # attr_accessible :title, :body
end
