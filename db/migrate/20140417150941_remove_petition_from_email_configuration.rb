class RemovePetitionFromEmailConfiguration < ActiveRecord::Migration
	def change
	    remove_index :email_configurations, :petition_id
		remove_column :email_configurations, :petition_id
	end
end
