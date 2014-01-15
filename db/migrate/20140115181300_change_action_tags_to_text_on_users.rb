class ChangeActionTagsToTextOnUsers < ActiveRecord::Migration
	def up
	    change_column :users, :action_tags, :text
	end
	def down
	    # This might cause trouble if you have strings longer
	    # than 255 characters.
	     change_column :users, :action_tags, :string
	end
end
