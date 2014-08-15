class AddPollChoiceRefToPollResponses < ActiveRecord::Migration
  def change
    add_reference :poll_responses, :poll_choice, index: true
  end
end
