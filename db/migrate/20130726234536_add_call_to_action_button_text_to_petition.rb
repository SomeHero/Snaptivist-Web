class AddCallToActionButtonTextToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :call_to_action_button_text, :string
  end
end
