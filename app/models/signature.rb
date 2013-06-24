class Signature < ActiveRecord::Base
  belongs_to :user
  belongs_to :petition, :counter_cache => true
  attr_accessible :comment

  validates :user, :presence => true

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      # populate your model
      obj.city    = geo.city
      obj.state= geo.state #geo.state_code
      obj.country = geo.country_code
    end
  end
  geocoded_by :zip_code do |obj, results|
    if geo = results.first
      # populate your model
      obj.latitude = geo.latitude
      obj.longitude = geo.longitude
    end
  end
  after_validation :geocode, :reverse_geocode
  
     # generate the petition
  def to_api

    results = {
      'signature_id' => id,
      'petition_id' => petition.id,
      'user_id' => user.id,
      'comment' => comment,
      'created_at' => created_at,
      'updated_at' => updated_at
    }

    return results;

  end
  
end

