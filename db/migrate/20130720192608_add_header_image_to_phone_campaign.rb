class AddHeaderImageToPhoneCampaign < ActiveRecord::Migration
  def change
  	add_attachment :phone_campaigns, :header_image
  end
end
