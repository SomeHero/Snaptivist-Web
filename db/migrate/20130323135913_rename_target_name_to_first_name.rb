class RenameTargetNameToFirstName < ActiveRecord::Migration
  def change
    rename_column :targets, :name, :first_name
  end
end
