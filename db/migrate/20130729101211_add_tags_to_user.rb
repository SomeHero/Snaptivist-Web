class AddTagsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :action_tags, :string
  end
end
