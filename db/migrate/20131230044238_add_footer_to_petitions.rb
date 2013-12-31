class AddFooterToPetitions < ActiveRecord::Migration
  def change
  	add_attachment :petitions, :footer_image
  end
end