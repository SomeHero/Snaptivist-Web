class AddCommentToPhoneCampaign < ActiveRecord::Migration
  def change
  	  add_column :phone_campaigns, :comment, :string
  end
end
