class AddDefaultTweetCopyToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :default_tweet_text, :string
  end
end
