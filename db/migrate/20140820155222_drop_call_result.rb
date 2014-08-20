class DropCallResult < ActiveRecord::Migration
  def change
  	drop_table :call_results
  end
end
