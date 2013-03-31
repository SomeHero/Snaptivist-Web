require 'csv'

desc "Import state hashtags from csv file"
task :import_state_hashtags => [:environment] do

  file = "db/state hashtags.csv"

  CSV.foreach(file, :headers => true) do |row|
    StateInformation.create(
      :short_code => row[0],
      :state_name=> row[1],
      :political_hashtag => row[2],
    )
  end

end