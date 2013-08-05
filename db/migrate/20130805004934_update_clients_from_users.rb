class UpdateClientsFromUsers < ActiveRecord::Migration
  def up
  	User.where("organization_name is not null").each do |user|
  		Client.create({
  			:name => user.organization_name,
  			:user => user
  		})
  	end
  end

  def down
  	Client.destroy_all
  end
end
