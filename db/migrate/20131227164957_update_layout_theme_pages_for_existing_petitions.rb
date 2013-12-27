class UpdateLayoutThemePagesForExistingPetitions < ActiveRecord::Migration
  def up
  	layout = Layout.find_by_name("Snaptivist Standard")
  	theme = layout.themes.find_by_name("Theme A")
  	signature_page = layout.pages.find_by_name("Signature Page")
  	delivery_page = layout.pages.find_by_name("Tweet Page")

  	petitions = Petition.all

  	petitions.each do |petition| 
  		petition.layout = layout
  		petition.theme = theme
  		petition.pages << signature_page
  		petition.pages << delivery_page

  		petition.save!
  	end
  end

  def down
  end
end
