class RemoveChoiceRefFromPollResponse < ActiveRecord::Migration
  def change
  	remove_column :poll_responses, :choice_id
  end
end
