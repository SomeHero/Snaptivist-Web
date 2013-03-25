class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :poll_id
      t.integer :choice_id

      t.timestamps
    end
  end
end
