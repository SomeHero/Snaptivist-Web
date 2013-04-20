class CallResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :phone_campaign, :counter_cache => true
  attr_accessible :comment, :result

  validates :user, :presence => true
  
     # generate the petition
  def to_api

    results = {
      'callresult_id' => id,
      'phonecampaign_id' => phone_campaign.id,
      'user_id' => user.id,
      'comment' => comment,
      'created_at' => created_at,
      'updated_at' => updated_at
    }

    return results;

  end
  
end
