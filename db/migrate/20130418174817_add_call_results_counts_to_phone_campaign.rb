class AddCallResultsCountsToPhoneCampaign < ActiveRecord::Migration
  def change
  	 add_column :phone_campaigns, :call_results_count, :integer
  end
end
