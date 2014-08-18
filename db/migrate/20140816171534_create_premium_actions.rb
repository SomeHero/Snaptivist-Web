class CreatePremiumActions < ActiveRecord::Migration
  def change
    create_table :premium_actions do |t|

      t.timestamps
    end
  end
end
