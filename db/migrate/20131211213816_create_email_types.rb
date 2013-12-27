class CreateEmailTypes < ActiveRecord::Migration
  def change
    create_table :email_types do |t|
      t.string :name
      t.string :description
      t.string :default_email_template

      t.timestamps
    end
  end
end
