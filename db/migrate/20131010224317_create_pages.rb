class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :description
      t.string :template_name
      t.references :layout

      t.timestamps
    end
    add_index :pages, :layout_id
  end
end
