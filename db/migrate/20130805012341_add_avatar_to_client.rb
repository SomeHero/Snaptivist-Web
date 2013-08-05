class AddAvatarToClient < ActiveRecord::Migration
  def change
  	add_attachment :clients, :avatar
  end
end
