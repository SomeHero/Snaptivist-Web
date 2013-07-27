class AddTargetAddressHeadlineToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :target_headline_text, :string
  end
end
