class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :user
      t.string :source
      t.decimal :amount
      t.datetime :submitted_date
      t.datetime :cancelled_date
      t.string :donation_status
      t.string :string

      t.timestamps
    end
    add_index :donations, :user_id
  end
end
