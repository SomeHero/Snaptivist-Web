class PollAction < Action
 has_many :poll_choices
 
 accepts_nested_attributes_for :poll_choices,
 :reject_if => proc { |att| att['label'].blank? },
 :allow_destroy => true

  def to_api

    results = {
      'id' => id,
      'type' => "poll_action",
      'name' => name,
      'poll_choices_attributes' => poll_choices.map { |poll_choice| poll_choice.to_api },
      'count' => get_count
    }

    return results;
  end

  def self.create_or_update_poll action
    self.update(action)
  end

end
