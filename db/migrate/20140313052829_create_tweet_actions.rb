class CreateTweetActions < ActiveRecord::Migration
  def change
    create_table :tweet_actions do |t|
      t.string :twitter_handle

      t.timestamps
    end
  end
end
