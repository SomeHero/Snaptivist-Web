class CreateUserNotificationLogs < ActiveRecord::Migration
  def change
    create_table :user_notification_logs do |t|
      t.references :user
      t.string :notification_type
      t.string :notification_uri
      t.boolean :sent
      t.boolean :test

      t.timestamps
    end
    add_index :user_notification_logs, :user_id
  end
end
