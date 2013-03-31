class CreateStateInformations < ActiveRecord::Migration
  def change
    create_table :state_informations do |t|
      t.string :state_name
      t.string :short_code
      t.string :political_hashtag

      t.timestamps
    end
  end
end
