class CreatePremiumOffers < ActiveRecord::Migration
  def change
    create_table :premium_offers do |t|
      t.string :name
      t.string :headline_text
      t.string :call_to_action_button_text

      t.timestamps
    end
  end
end
