require 'csv'

desc "Import state targets from csv file"
task :import_state_targets => [:environment] do

  file = "db/state.csv"

  CSV.foreach(file, :headers => true) do |row|
    Target.create(
      :title => row[0],
      :first_name => row[1],
      :middle_name => row[2],
      :last_name => row[3],
      :name_suffix => row[4],
      :nickname => row[5],
      :party => row[6],
      :state => row[7],
      :district => row[8],
      :in_office => row[9],
      :gender => row[10],
      :phone => row[11],
      :fax => row[12],
      :website => row[13],
      :webform => row[14],
      :congress_office => row[15],
      :bioguide_id => row[16],
      :votesmart_id => row[17],
      :fec_id => row[18],
      :govtrack_id => row[19],
      :crp_id => row[20],
      :twitter_handle => row[21],
      :congresspedia_url => row[22],
      :youtube_url => row[23],
      :facebook_id => row[24],
      :official_rss => row[25],
      :senate_class => row[26],
      :birthdate => row[27],
      :targetgroup_id => 3
    )
  end

end