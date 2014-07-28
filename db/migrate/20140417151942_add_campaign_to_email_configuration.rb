class AddCampaignToEmailConfiguration < ActiveRecord::Migration
  def change
  	add_column :email_configurations, :campaign_id, :integer
  	add_index :email_configurations, :campaign_id
  end
end
