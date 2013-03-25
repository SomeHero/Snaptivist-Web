class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string :choice
      t.integer :poll_id

      t.timestamps
    end
  end
end
