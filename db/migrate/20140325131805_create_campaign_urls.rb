class CreateCampaignUrls < ActiveRecord::Migration
  def change
    create_table :campaign_urls do |t|
      t.references :campaign
      t.references :url

      t.timestamps
    end
    add_index :campaign_urls, :campaign_id
    add_index :campaign_urls, :url_id
  end
end
