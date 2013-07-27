class AddCommentPlaceHolderTextToPetition < ActiveRecord::Migration
  def change
  	  add_column :petitions, :signature_comment_placeholder_text, :string
  end
end
