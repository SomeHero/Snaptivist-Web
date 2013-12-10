class AddUnSponsoredToPetitions < ActiveRecord::Migration
  def change
  	add_column :petitions, :unsponsored, :boolean, :default => false

  	Petition.update_all({ :unsponsored => false })
  end
end
