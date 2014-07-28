class AddLayoutAndThemeToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :layout_id, :integer
  	add_column :campaigns, :theme_id, :integer
  end
end
