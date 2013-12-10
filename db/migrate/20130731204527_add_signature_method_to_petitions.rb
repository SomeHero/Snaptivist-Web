class AddSignatureMethodToPetitions < ActiveRecord::Migration
  def change
  	add_column :signatures, :signature_method, :string
  end
end
