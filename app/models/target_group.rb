class TargetGroup < ActiveRecord::Base
	has_many :targets
  attr_accessible :name
end
