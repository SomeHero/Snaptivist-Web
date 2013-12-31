class CreateClientSupporters < ActiveRecord::Migration
  def change
    create_table :client_supporters do |t|
      t.references :client
      t.references :user

      t.timestamps
    end
    add_index :client_supporters, :client_id
    add_index :client_supporters, :user_id
  end
end
