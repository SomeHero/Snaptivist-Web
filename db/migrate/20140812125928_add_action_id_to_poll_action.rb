class AddActionIdToPollAction < ActiveRecord::Migration
  def change
  	add_column :poll_actions, :action_id, :integer
  end
end
