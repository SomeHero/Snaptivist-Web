class AddSharedPropertiesToSignature < ActiveRecord::Migration
  def change
  	add_column :signatures, :shared, :boolean
  	add_column :signatures, :shared_at, :datetime
  end
end
