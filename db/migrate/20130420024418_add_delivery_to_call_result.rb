class AddDeliveryToCallResult < ActiveRecord::Migration
  def change
  	  add_column :call_results, :delivered, :boolean
  		add_column :call_results, :delivered_at, :datetime
  end
end
