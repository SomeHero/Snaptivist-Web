class Poll < ActiveRecord::Base
  attr_accessible :question, :rewrite_url_key, :short_url
  has_many :choices

  # generate the poll
  def to_api

    results = {
      'poll_id' => id,
      'question' => question,
      'short_url' => short_url,
      'rewrite_url_key' => rewrite_url_key,
    }
    results[:choices] = []

    self.choices.each do |choice|
        results[:choices] << choice.to_api()
    end
    
    return results;

  end
end
