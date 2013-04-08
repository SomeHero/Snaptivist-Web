class AddUserIdToPhoneCampaign < ActiveRecord::Migration
  def change
  	add_column :phone_campaigns, :user_id, :integer
  end
end
