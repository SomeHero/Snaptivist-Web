class AddTweetToSignature < ActiveRecord::Migration
  def change
  	add_column :signatures, :tweet_id, :integer
  end
end
