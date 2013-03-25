class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :question
      t.string :short_url
      t.string :rewrite_url_key

      t.timestamps
    end
  end
end
