class AddDonationPageUrlToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :donation_page_url, :string
  end
end
