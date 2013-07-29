class AddTweetCtaButtonTextToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :tweet_cta_button_text, :string
  end
end
