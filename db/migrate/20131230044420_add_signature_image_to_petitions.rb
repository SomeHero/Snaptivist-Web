class AddSignatureImageToPetitions < ActiveRecord::Migration
  def change
  	add_attachment :petitions, :signature_image
  end
end
