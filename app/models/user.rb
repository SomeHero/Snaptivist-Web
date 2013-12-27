class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  # holds the twitter client
  attr_accessor :twitter_client

  has_many :authentications, :dependent => :destroy, :autosave => true
  has_many :external_accounts, :dependent => :destroy
  has_many :signatures, :dependent => :destroy
  has_many :call_results, :dependent => :destroy

  has_attached_file :organization_avatar, styles: {
    small: '128x128',
    medium: '256x256',
    large: '512x512',
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"

  IMAGE_SIZES = {"small" => "128x128",
                "medium" => "256x256",
                "large" => "512x512"}
    # note that the user has authenticated
  # def process_authentication
  #   if (is_gifter || Parameter.is_set?(Parameter::OPEN_BETA)) && welcomed_at.nil? && !email.blank?
  #     begin
  #       TreaterMailer.send_email(:welcome_email, self)
  #     rescue => e
  #       logger.error e.message
  #       logger.error e.backtrace
  #     end
  #     self.welcomed_at = Time.now
  #     save
  #   end
  # end
def display_name
  self.organization_name
end

def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'], 
                          :uid => omni['uid'], 
                          :token => omni['credentials'].token, 
                          :token_secret => omni['credentials'].secret)
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super #&& provider.blank?
  end
  
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
  # returns true if user has twitter tokens
  def twitter?
    self.twitter_token && self.twitter_secret
  end

  # returns an instance of TwitterOAuth::Client if user has twitter tokens
  def twitter
    if twitter?
      return self.twitter_client if self.twitter_client
      self.twitter_client = TwitterOAuth::Client.new(
          :consumer_key => TWITTER_CONSUMER_KEY,
          :consumer_secret => TWITTER_CONSUMER_SECRET,
          :token => self.twitter_token,
          :secret => self.twitter_secret
      )
    else
      false
    end
  end

  def display_name 
    "#{first_name} #{last_name} (#{organization_name})"
  end

  # generate the user as json
  def to_api

    results = {
      'user_id' => id,
      'first_name' => first_name,
      'last_name' => last_name[0,1],
      'organization_name' => organization_name,
      'zip_code' => zip_code,
      'avatar_url' => avatar_url
    }

    User::IMAGE_SIZES.each do |label, size|
      results["image_#{label}"] = organization_avatar(label)
    end

    return results;
  end
  
end
