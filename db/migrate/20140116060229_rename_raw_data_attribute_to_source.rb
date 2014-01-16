class RenameRawDataAttributeToSource < ActiveRecord::Migration
  def up
  	rename_column :raw_data, :attribute, :source
  end

  def down
  	rename_column :raw_data, :source, :attribute
  end
end
