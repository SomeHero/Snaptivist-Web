class AddCommentToPolls < ActiveRecord::Migration
  def change
  	  add_column :polls, :comment, :string
  end
end
