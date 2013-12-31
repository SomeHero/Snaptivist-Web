class AddDeliveryImageToPetitions < ActiveRecord::Migration
  def change
  	add_attachment :petitions, :delivery_image
  end
end
