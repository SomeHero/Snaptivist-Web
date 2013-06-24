class AddLatitudeLongitudeToSignature < ActiveRecord::Migration
  def change
  	add_column :signatures, :latitude, :float
  	add_column :signatures, :longitude, :float
  	add_column :signatures, :city, :string
  	add_column :signatures, :state, :string
  	add_column :signatures, :country, :string
  end
end
