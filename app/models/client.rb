class Client < ActiveRecord::Base

  devise :database_authenticatable, :timeoutable

  has_attached_file :avatar, styles: {
    small: '128x128',
    medium: '256x256',
    large: '512x512',
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"

  IMAGE_SIZES = {"small" => "128x128",
                "medium" => "256x256",
                "large" => "512x512"}

    # generate the user as json
  def to_api

    results = {
      'client_id' => id,
      'name' => name
    }

    Client::IMAGE_SIZES.each do |label, size|
      results["image_#{label}"] = avatar(label)
    end

    return results;
  end

end
