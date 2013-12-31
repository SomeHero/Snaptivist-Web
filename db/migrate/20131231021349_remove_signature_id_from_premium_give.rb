class RemoveSignatureIdFromPremiumGive < ActiveRecord::Migration
  def change
  	remove_column :premium_gives, :signature_id
  end
end
