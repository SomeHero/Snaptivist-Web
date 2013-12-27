class CreateEmailConfigurations < ActiveRecord::Migration
  def change
    create_table :email_configurations do |t|
      t.references :email_type
      t.references :petition
      t.string :from_name
      t.string :from_address
      t.string :subject
      t.string :email_template
      t.string :last_id_sent

      t.timestamps
    end
    add_index :email_configurations, :email_type_id
    add_index :email_configurations, :petition_id
  end
end
