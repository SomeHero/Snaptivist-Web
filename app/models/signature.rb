class Signature < ActiveRecord::Base
  belongs_to :user
  belongs_to :petition
  attr_accessible :comment
end
