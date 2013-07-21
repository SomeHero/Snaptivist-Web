class AddSubdomainToPhoneCampaigns < ActiveRecord::Migration
  def change
  	add_column :phone_campaigns, :subdomain, :string
  end
end
