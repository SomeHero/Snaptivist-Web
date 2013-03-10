class CreateExternalAccounts < ActiveRecord::Migration
  def change
    create_table :external_accounts do |t|
      t.string :type
      t.string :external_id
      t.references :user
      t.string :email
      t.datetime :authenticated_at
      t.datetime :allowed_at

      t.timestamps
    end
    add_index :external_accounts, :user_id
  end
end
