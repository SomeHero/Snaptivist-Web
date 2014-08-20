class DropPhoneCampaignsTable < ActiveRecord::Migration
  def change
  	drop_table :phone_campaigns
  end
end