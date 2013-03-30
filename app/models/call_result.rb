class CallResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :phone_campaign, :counter_cache => true
  attr_accessible :comment, :result
end
