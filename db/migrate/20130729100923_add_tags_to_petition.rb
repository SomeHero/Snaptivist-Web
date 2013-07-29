class AddTagsToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :action_tags, :string
  end
end
