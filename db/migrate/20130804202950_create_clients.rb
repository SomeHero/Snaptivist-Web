class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :clients, :user_id
  end
end
