class CreatePetitionPages < ActiveRecord::Migration
  def change
    create_table :petition_pages do |t|
      t.references :petition
      t.references :page
      t.integer :position

      t.timestamps
    end
    add_index :petition_pages, :petition_id
    add_index :petition_pages, :page_id
  end
end
