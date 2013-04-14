class Signature < ActiveRecord::Base
  belongs_to :user
  belongs_to :petition, :counter_cache => true
  attr_accessible :comment

  validates :user, :presence => true
  
end

