class CreateCampaignPageUrls < ActiveRecord::Migration
  def change
    create_table :campaign_page_urls do |t|
      t.references :campaign_page
      t.references :url

      t.timestamps
    end
    add_index :campaign_page_urls, :campaign_page_id
    add_index :campaign_page_urls, :url_id
  end
end
