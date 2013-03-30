class CreatePollResponses < ActiveRecord::Migration
  def change
    create_table :poll_responses do |t|
      t.string :comment
      t.references :poll
      t.references :choice

      t.timestamps
    end
    add_index :poll_responses, :poll_id
    add_index :poll_responses, :choice_id
  end
end
