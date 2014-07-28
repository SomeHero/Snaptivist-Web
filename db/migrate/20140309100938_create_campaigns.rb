class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.string :subdomain
      t.references :client

      t.timestamps
    end
    add_index :campaigns, :client_id
  end
end
