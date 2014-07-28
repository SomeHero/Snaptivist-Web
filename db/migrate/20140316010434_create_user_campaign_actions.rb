class CreateUserCampaignActions < ActiveRecord::Migration
  def change
    create_table :user_campaign_actions do |t|
      t.references :user
      t.references :campaign
      t.references :action
      t.string :type

      t.timestamps
    end
    add_index :user_campaign_actions, :user_id
    add_index :user_campaign_actions, :campaign_id
    add_index :user_campaign_actions, :action_id
  end
end
