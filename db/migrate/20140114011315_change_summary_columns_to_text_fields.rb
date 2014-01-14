class ChangeSummaryColumnsToTextFields < ActiveRecord::Migration
	def up
	    change_column :petitions, :delivery_summary, :text
	    change_column :petitions, :premium_summary, :text
	end
	def down
	    # This might cause trouble if you have strings longer
	    # than 255 characters.
	     change_column :petitions, :delivery_summary, :string
	     change_column :petitions, :premium_summary, :string
	end
end
