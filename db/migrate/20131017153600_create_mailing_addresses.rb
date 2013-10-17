class CreateMailingAddresses < ActiveRecord::Migration
  def change
    create_table :mailing_addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :string
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.string :email_address

      t.timestamps
    end
  end
end
