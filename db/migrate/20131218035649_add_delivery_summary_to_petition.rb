class AddDeliverySummaryToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :delivery_summary, :string
  end
end
