class CreateClientUsers < ActiveRecord::Migration
  def change
    create_table :client_users do |t|
      t.references :client
      t.references :user

      t.timestamps
    end
    add_index :client_users, :client_id
    add_index :client_users, :user_id
  end
end
