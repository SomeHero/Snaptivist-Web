class Action < ActiveRecord::Base
  #attr_accessible :name, :type
  has_one :campaign_page
  has_many :user_campaign_actions

  def to_api

    results = {
      'id' => id,
      'type' => 'action',
      'name' => name,
      'count' => get_count
    }

    return results;

  end

  def get_count
  	UserCampaignAction.where("action_id" => self.id).count
  end

end
