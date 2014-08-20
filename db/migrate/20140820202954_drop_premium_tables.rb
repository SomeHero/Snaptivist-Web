class DropPremiumTables < ActiveRecord::Migration
  def change
  	drop_table :premium_gives
  	drop_table :premium_offers
  end
end
