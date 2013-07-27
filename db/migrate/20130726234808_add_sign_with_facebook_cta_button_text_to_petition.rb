class AddSignWithFacebookCtaButtonTextToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :sign_with_facebook_cta_button_text, :string
  end
end
