class AddDisclaimerTextToPetition < ActiveRecord::Migration
  def change
  	add_column :petitions, :disclaimer_text, :string
  end
end
