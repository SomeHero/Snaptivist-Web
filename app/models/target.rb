class Target < ActiveRecord::Base
  belongs_to:TargetGroup, :class_name => "TargetGroup" 	, :foreign_key => "targetgroup_id"
  attr_accessible :email_address, :first_name, :middle_name, :last_name, :name_suffix, :nickname, :party, :state, :district, :in_office, :gender, :phone, :fax, :website, :webform, :congress_office, :bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :crp_id, :congresspedia_url, :youtube_url, :facebook_id, :official_rss, :senate_class, :birthdate, :title, :twitter_handle, :targetgroup_id
end
