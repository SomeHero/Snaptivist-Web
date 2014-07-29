class CreateCampaignPages2 < ActiveRecord::Migration
  def change
    create_table :campaign_pages do |t|
      t.references :campaign
      t.references :page
      t.integer :position

      t.timestamps
    end
    add_index :campaign_pages, :campaign_id
    add_index :campaign_pages, :page_id
  end
end
