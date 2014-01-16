class CreateRawData < ActiveRecord::Migration
  def change
    create_table :raw_data do |t|
      t.string :type
      t.string :attribute
      t.text :raw_data

      t.timestamps
    end
  end
end
