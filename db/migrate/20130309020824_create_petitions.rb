class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.string :title
      t.string :summary
      t.integer :target_count
      t.references :target
      t.string :short_url
      t.string :rewrite_url_key

      t.timestamps
    end
    add_index :petitions, :target_id
  end
end
