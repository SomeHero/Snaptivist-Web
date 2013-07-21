class AddSubdomainToPoll < ActiveRecord::Migration
  def change
  	add_column :polls, :subdomain, :string
  end
end
