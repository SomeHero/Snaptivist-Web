class CreateActionResponses < ActiveRecord::Migration
  def change
    create_table :action_responses do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :zip_code
      t.references :user, index: true
      t.references :action, index: true

      t.timestamps
    end
  end
end
