class AddSeeMoreSignersToMoreSignersButton < ActiveRecord::Migration
  def up
  	petitions = Petition.all

  	petitions.each do |petition| 
  		petition.signature_more_signers_button_text = "See More Signers"

  		petition.save!
  	end
  end

  def down
  end
end
