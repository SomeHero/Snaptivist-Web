class AddHeadlinesToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :headline_primary, :string
  	add_column :petitions, :headline_secondary, :string
  	add_column :petitions, :subheadline, :string
  end
end
