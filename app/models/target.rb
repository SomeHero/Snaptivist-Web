class Target < ActiveRecord::Base
  belongs_to:target_group, :class_name => "TargetGroup", :foreign_key => "targetgroup_id"
  belongs_to:state_information, :class_name => "StateInformation", :foreign_key => "state_information_id"

  attr_accessible :email_address, :first_name, :middle_name, :last_name, :name_suffix, :nickname, :party, :state, :district, :in_office, :gender, :phone, :fax, :website, :webform, :congress_office, :bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :crp_id, :congresspedia_url, :youtube_url, :facebook_id, :official_rss, :senate_class, :birthdate, :title, :twitter_handle, :targetgroup_id

    # generate the team
  def to_api

    results = {
      'target_id' => id,
      'targetgroup_id' => targetgroup_id,
      'title' => title,
      'first_name' => first_name,
      'middle_name' => middle_name,
      'last_name' => last_name,
      'name_suffix' => name_suffix,
      'nickname' => nickname,
      'party' => party,
      'state' => state,
      'district' => district,
      'in_office' => in_office,
      'gender' => gender,
      'phone' => phone,
      'fax' => fax,
      'website' => website,
      'webform' => webform,
      'congress_office' => congress_office,
      'bioguide_id' => bioguide_id,
      'votesmart_id' => votesmart_id,
      'fec_id' => fec_id,
      'govtrack_id' => govtrack_id,
      'crp_id' => crp_id,
      'congresspedia_url' => congresspedia_url,
      'youtube_url' => youtube_url,
      'facebook_id' => facebook_id,
      'official_rss' => official_rss,
      'senate_class' => senate_class,
      'birthdate' => birthdate,
      'title' => title,
      'twitter_handle' => twitter_handle,
      'target_group' => target_group.to_api
    }

    return results;

  end
end
