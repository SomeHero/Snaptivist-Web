class Choice < ActiveRecord::Base
  attr_accessible :choice, :poll_id
  belongs_to :poll

    # generate the poll
  def to_api

    results = {
      'poll_id' => id,
      'choice' => choice
    }

    return results;

  end
end
