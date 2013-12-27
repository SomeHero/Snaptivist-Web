class AddLayoutIdToTheme < ActiveRecord::Migration
  def change
  	add_column :themes, :layout_id, :integer
  end
end
