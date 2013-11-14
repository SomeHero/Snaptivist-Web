class AddPremiumHeadlinesToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :premium_headline_primary, :string
  	add_column :petitions, :premium_headline_secondary, :string
  	add_column :petitions, :premium_subheadline, :string
  end
end
