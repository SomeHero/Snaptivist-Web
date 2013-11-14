class AddDeliveryCallToActionButtonTextToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :delivery_call_to_action_text, :string
  	add_column :petitions, :delivery_call_to_action_button_text, :string
  	add_column :petitions, :delivery_skip_button_text, :string
  	add_column :petitions, :delivery_more_tweets_button_text, :string
  end
end
