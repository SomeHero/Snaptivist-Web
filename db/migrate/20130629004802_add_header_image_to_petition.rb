class AddHeaderImageToPetition < ActiveRecord::Migration
  def change
  	add_attachment :petitions, :header_image
  end
end
