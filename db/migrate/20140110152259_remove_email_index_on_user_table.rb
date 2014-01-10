class RemoveEmailIndexOnUserTable < ActiveRecord::Migration
  def up
  	remove_index "users", ["email"]
  end

  def down
  	add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  end
end
