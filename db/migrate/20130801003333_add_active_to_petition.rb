class AddActiveToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :active, :boolean, :default => false

  	Petition.update_all({ :active => true })
  end
end
