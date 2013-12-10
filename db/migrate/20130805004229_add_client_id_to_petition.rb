class AddClientIdToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :client_id, :integer
  end
end
