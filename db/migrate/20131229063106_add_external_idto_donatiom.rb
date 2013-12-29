class AddExternalIdtoDonatiom < ActiveRecord::Migration
  def change
  	add_column :donations, :external_id, :string
  end
end
