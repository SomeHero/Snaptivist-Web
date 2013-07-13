class AddCommentToPetitions < ActiveRecord::Migration
  def change
  	  add_column :petitions, :comment, :string
  end
end
