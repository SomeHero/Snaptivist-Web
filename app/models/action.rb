class Action < ActiveRecord::Base
  #attr_accessible :name, :type
  has_one :campaign_page

  def get_count
  	UserCampaignAction.where("action_id" => self.id).count
  end

end
