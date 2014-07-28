class CreatePetitionActions < ActiveRecord::Migration
  def change
    create_table :petition_actions do |t|

      t.timestamps
    end
  end
end
