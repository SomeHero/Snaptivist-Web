class AddReasonToUserCampaignAction < ActiveRecord::Migration
  def change
  	add_column :user_campaign_actions, :reason, :string
  end
end
