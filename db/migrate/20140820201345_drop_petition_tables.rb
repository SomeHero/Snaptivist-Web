class DropPetitionTables < ActiveRecord::Migration
  def change
  	drop_table :petitions
  	drop_table :petition_pages
  end
end
