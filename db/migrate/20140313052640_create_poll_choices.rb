class CreatePollChoices < ActiveRecord::Migration
  def change
    create_table :poll_choices do |t|
      t.string :label
      t.integer :position
      t.references :poll_action

      t.timestamps
    end
    add_index :poll_choices, :poll_action_id
  end
end
