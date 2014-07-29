class StateInformation < ActiveRecord::Base
  has_many :targets
  #attr_accessible :political_hashtag, :short_code, :state_name
end
