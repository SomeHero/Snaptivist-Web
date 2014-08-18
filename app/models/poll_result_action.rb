class PollResultAction < Action
	belongs_to :poll, class_name: 'PollAction'

  def to_api

    results = {
      'id' => id,
      'type' => "poll_results",
      'name' => name,
      'poll' => poll ? poll.to_api : nil,
      'count' => get_count
    }

    return results;
  end

end
