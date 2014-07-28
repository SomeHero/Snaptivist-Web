class AddPollChoiceToUserCampaignAction < ActiveRecord::Migration
  def change
  	add_column :user_campaign_actions, :poll_choice_id, :integer
  end
end
