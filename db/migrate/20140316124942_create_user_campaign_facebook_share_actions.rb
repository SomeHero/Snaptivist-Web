class CreateUserCampaignFacebookShareActions < ActiveRecord::Migration
  def change
    create_table :user_campaign_facebook_share_actions do |t|

      t.timestamps
    end
  end
end
