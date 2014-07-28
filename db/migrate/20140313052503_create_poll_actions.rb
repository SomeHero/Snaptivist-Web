class CreatePollActions < ActiveRecord::Migration
  def change
    create_table :poll_actions do |t|

      t.timestamps
    end
  end
end
