class CreatePhoneCampaigns < ActiveRecord::Migration
  def change
    create_table :phone_campaigns do |t|
      t.string :title
      t.string :summary
      t.integer :target_count
      t.string :short_url
      t.string :rewrite_url_key
      t.references :target

      t.timestamps
    end
    add_index :phone_campaigns, :target_id
  end
end
