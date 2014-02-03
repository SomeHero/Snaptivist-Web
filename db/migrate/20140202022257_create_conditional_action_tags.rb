class CreateConditionalActionTags < ActiveRecord::Migration
  def change
    create_table :conditional_action_tags do |t|
      t.references :petition
      t.references :conditional_action_type_type
      t.string :action_tags

      t.timestamps
    end
    add_index :conditional_action_tags, :petition_id, :name => 'petition_conditional_action_tag_index'
    add_index :conditional_action_tags, :conditional_action_type_type_id, :name => 'conditional_action_tag_type_index'
  end
end
