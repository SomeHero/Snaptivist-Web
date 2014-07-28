class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
