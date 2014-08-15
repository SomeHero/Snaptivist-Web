class AddTypeToActionResponses < ActiveRecord::Migration
  def change
  	add_column :action_responses, :type, :string
  end
end
