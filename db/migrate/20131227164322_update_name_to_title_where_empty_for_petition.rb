class UpdateNameToTitleWhereEmptyForPetition < ActiveRecord::Migration
  def up
  	petitions = Petition.all

  	petitions.each do |petition| 
  		petition.name = petition.title if petition.name.blank?
  		petition.save!
  	end
  end

  def down
  end
end
