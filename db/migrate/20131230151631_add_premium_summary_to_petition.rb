class AddPremiumSummaryToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :premium_summary, :string
  end
end
