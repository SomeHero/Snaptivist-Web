class CreateCallResults < ActiveRecord::Migration
  def change
    create_table :call_results do |t|
      t.string :result
      t.string :comment
      t.references :phone_campaign

      t.timestamps
    end
    add_index :call_results, :phone_campaign_id
  end
end
