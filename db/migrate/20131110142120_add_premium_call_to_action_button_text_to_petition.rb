class AddPremiumCallToActionButtonTextToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :premium_call_to_action_text, :string
  	add_column :petitions, :premium_call_to_action_button_text, :string
  	add_column :petitions, :premium_skip_button_text, :string
  end
end
