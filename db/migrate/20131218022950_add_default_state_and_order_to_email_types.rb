class AddDefaultStateAndOrderToEmailTypes < ActiveRecord::Migration
  def change
  	add_column :email_types, :default_state, :boolean
  	add_column :email_types, :position, :integer
  end
end
