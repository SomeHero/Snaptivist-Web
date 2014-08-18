class CreateDonationActions < ActiveRecord::Migration
  def change
    create_table :donation_actions do |t|

      t.timestamps
    end
  end
end
