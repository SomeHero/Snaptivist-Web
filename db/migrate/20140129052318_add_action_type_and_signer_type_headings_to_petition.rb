class AddActionTypeAndSignerTypeHeadingsToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :action_type_header_name, :string
  	add_column :petitions, :signer_type_header_name, :string
  end
end
