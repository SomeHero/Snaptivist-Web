class CreateUserRawData < ActiveRecord::Migration
  def change
    create_table :user_raw_data do |t|
      t.references :user
      t.references :raw_data

      t.timestamps
    end
    add_index :user_raw_data, :user_id
    add_index :user_raw_data, :raw_data_id
  end
end
