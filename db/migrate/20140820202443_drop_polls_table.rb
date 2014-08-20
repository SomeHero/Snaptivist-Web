class DropPollsTable < ActiveRecord::Migration
  def change
  	drop_table :polls
  end
end
