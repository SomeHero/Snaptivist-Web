class TargetGroup < ActiveRecord::Base
	has_many :targets
  attr_accessible :name

   # generate the target group
  def to_api

    results = {
      'targetgroup_id' => id,
      'name' => name
    }

    return results;

  end
end
