class RenameConditionalActionTypeToConditionalActionTagType < ActiveRecord::Migration
  def up
  	rename_column :conditional_action_tags, :conditional_action_type_type_id, :conditional_action_tag_type_id
  end

  def down
  	rename_column :conditional_action_tags, :conditional_action_type_tag_id, :conditional_action_type_type_id
  end
end
