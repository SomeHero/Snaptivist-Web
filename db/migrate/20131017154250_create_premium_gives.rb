class CreatePremiumGives < ActiveRecord::Migration
  def change
    create_table :premium_gives do |t|
      t.references :user
      t.references :signature
      t.references :mailing_address

      t.timestamps
    end
    add_index :premium_gives, :user_id
    add_index :premium_gives, :signature_id
    add_index :premium_gives, :mailing_address_id
  end
end
