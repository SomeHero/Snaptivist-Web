class ChangeDeliveryHeadlinesFromSignatureToDelivery < ActiveRecord::Migration
  def up
  	rename_column :petitions, :signature_headline_primary, :delivery_headline_primary
  	rename_column :petitions, :signature_headline_secondary, :delivery_headline_secondary
  	rename_column :petitions, :signature_subheadline, :delivery_subheadline
  end

  def down
  	rename_column :petitions, :delivery_headline_primary, :signature_headline_primary
  	rename_column :petitions, :delivery_headline_secondary, :signature_headline_secondary
  	rename_column :petitions, :delivery_subheadline, :signature_subheadline
  end
end
