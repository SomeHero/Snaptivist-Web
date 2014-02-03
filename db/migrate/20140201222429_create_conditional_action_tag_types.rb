class CreateConditionalActionTagTypes < ActiveRecord::Migration
  def change
    create_table :conditional_action_tag_types do |t|
      t.string :name
      t.string :label
      t.string :event_trigger

      t.timestamps
    end
  end
end
