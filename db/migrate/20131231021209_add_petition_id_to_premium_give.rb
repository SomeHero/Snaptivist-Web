class AddPetitionIdToPremiumGive < ActiveRecord::Migration
  def change
  	add_column :premium_gives, :petition_id, :integer
  end
end
