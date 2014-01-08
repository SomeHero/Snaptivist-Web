class AddStatusToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :status, :string, :default => "Draft"
  end
end
