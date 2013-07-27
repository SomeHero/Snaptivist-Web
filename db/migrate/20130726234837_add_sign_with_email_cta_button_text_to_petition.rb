class AddSignWithEmailCtaButtonTextToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :sign_with_email_cta_button_text, :string
  end
end
