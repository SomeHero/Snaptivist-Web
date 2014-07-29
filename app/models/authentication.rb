class Authentication < ActiveRecord::Base
  #attr_accessible :user_id, :provider, :uid, :token, :token_secret, :avatar_url
  belongs_to :user

end
