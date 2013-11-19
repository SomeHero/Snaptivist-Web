class AddPremiumImageToPetition < ActiveRecord::Migration
  def change
  	add_attachment :petitions, :premium_image
  end
end
