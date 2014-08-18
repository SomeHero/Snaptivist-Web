class AddPollIdToAction < ActiveRecord::Migration
  def change
  	add_column :actions, :poll_id, :integer
  end
end
