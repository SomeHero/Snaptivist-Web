class CreateNationBuilderCrmAuthentications < ActiveRecord::Migration
  def change
    create_table :nation_builder_crm_authentications do |t|
      t.string :nation_name
      t.string :client_app_id
      t.string :client_secret
      t.string :access_token
      t.string :redirect_uri

      t.timestamps
    end
  end
end
