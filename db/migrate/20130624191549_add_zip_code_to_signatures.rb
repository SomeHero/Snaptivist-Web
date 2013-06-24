class AddZipCodeToSignatures < ActiveRecord::Migration
  def change
  	add_column :signatures, :zip_code, :string
  end
end
