class AddActionIdToCampaignPages < ActiveRecord::Migration
  def change
  	add_column :campaign_pages, :action_id, :integer
  end
end
