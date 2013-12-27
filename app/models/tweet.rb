class Tweet < ActiveRecord::Base
  attr_accessible :message

  # generate the tweet
  def to_api

    results = {
      'tweet_id' => id,
      'message' => message,
      'created_at' => created_at,
      'updated_at' => updated_at,
    }

    return results;

  end
end
