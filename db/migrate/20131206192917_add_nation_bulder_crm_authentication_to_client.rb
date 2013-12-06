class AddNationBulderCrmAuthenticationToClient < ActiveRecord::Migration
  def change
  	add_column :clients, :nation_builder_crm_authentication_id, :integer
  end
end
