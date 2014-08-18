class AddCommentsToActionResponse < ActiveRecord::Migration
  def change
  	add_column :action_responses, :comments, :string
  end
end
