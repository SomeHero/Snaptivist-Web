class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.string :name
      t.string :title
      t.string :twitter_handle
      t.string :email_address

      t.timestamps
    end
  end
end
