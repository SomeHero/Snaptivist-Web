class AddUserIdToCallResult < ActiveRecord::Migration
  def change
  	  	add_column :call_results, :user_id, :integer
  end
end
