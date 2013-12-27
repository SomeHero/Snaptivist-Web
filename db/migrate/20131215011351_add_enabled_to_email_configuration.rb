class AddEnabledToEmailConfiguration < ActiveRecord::Migration
  def change
  	add_column :email_configurations, :enabled, :boolean
  end
end
