class CreateUserCampaignSignatureActions < ActiveRecord::Migration
  def change
    create_table :user_campaign_signature_actions do |t|
      t.string :reason

      t.timestamps
    end
  end
end
