class AddDeliveryHeadlinesToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :signature_headline_primary, :string
  	add_column :petitions, :signature_headline_secondary, :string
  	add_column :petitions, :signature_subheadline, :string
  end
end
