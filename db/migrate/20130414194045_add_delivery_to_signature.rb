class AddDeliveryToSignature < ActiveRecord::Migration
  def change
  	add_column :signatures, :delivered, :boolean
  	add_column :signatures, :delivered_at, :datetime
  end
end
