class AddSubdomainToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :subdomain, :string
  end
end
