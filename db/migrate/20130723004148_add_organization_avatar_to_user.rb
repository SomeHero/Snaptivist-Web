class AddOrganizationAvatarToUser < ActiveRecord::Migration
  def change
  	add_attachment :users, :organization_avatar
  end
end
