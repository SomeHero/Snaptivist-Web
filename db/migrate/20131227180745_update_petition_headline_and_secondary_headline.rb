class UpdatePetitionHeadlineAndSecondaryHeadline < ActiveRecord::Migration
  def up
  	petitions = Petition.all

  	petitions.each do |petition| 
  		petition.headline_primary = petition.target_headline_text
  		petition.headline_secondary = petition.title

  		petition.save!
  	end
  end

  def down
  end
end
