class Client < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :name, :avatar, :admin_users_attributes

  has_many :campaigns
  has_many :client_supporters
  has_many :supporters, through: :client_supporters, source: :user
  has_many :client_users
  has_many :admin_users, through: :client_users, source: :user

  belongs_to :nation_builder_crm_authentication

  accepts_nested_attributes_for :admin_users, :allow_destroy => :true

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
      'name' => name,
      'nation_builder' => nation_builder_crm_authentication ? nation_builder_crm_authentication.to_api : nil
    }

    Client::IMAGE_SIZES.each do |label, size|
      results["image_#{label}"] = avatar(label)
    end

    return results;
  end

end
