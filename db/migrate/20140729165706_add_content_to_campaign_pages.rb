class AddContentToCampaignPages < ActiveRecord::Migration
  def change
  	add_column :campaign_pages, :content, :json
  end
end
