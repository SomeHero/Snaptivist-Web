class CreateUserCampaignVoteActions < ActiveRecord::Migration
  def change
    create_table :user_campaign_vote_actions do |t|
      t.string :reason
      t.references :poll_choice

      t.timestamps
    end
    add_index :user_campaign_vote_actions, :poll_choice_id
  end
end
