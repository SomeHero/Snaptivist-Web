class SetDefaultActionTypeAndSignerTypeForExistingPetitions < ActiveRecord::Migration
  def up
  	petitions = Petition.all

  	petitions.each do |petition| 
  		petition.action_type_header_name = "Petition"
  		petition.signer_type_header_name = "Signers"

  		petition.save!
  	end
  end

  def down
  end
end
