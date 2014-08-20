class DropChoiceTable < ActiveRecord::Migration
  def change
  	drop_table :choices
  end
end
