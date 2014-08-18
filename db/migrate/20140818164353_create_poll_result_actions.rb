class CreatePollResultActions < ActiveRecord::Migration
  def change
    create_table :poll_result_actions do |t|

      t.timestamps
    end
  end
end
