class AddPremiumOfferToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :premium_offer_id, :integer
  end
end
