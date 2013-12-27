class AddSignatureMoreSignersButtonTextColumn < ActiveRecord::Migration
  def change
  	add_column :petitions, :signature_more_signers_button_text, :string
  end
end
