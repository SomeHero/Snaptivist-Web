class AddLayoutAndThemeToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :layout_id, :integer
  	add_column :petitions, :theme_id, :integer
  end
end