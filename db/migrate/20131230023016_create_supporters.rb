class CreateSupporters < ActiveRecord::Migration
  def change
    create_table :supporters do |t|
      t.references :client
      t.references :user

      t.timestamps
    end
    add_index :supporters, :client_id
    add_index :supporters, :user_id
  end
end
