class AddAvatarToAuthentication < ActiveRecord::Migration
  def change
  	add_column :authentications, :avatar_url, :string
  end
end
