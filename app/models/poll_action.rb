class PollAction < Action
 has_many :poll_choices
 #attr_accessible :id, :name, :poll_choices

  def to_api

    results = {
      'id' => id,
      'type' => 'Poll',
      'name' => name,
      'poll_choices' => poll_choices.map { |poll_choice| poll_choice.to_api },
      'count' => get_count
    }

    return results;
  end

  def self.create_or_update_poll action

  	poll = nil
  	if(action.id)
  		poll = PollAction.find(action.id)
  		poll.name = action.name
  		action.poll_choices.each do |poll_choice|
  		  if(poll_choice.id)
  		  	pc = poll.poll_choices.find(poll_choice.id)

  		  	pc.label = poll_choice.label
  		  	pc.position = poll_choice.position
  		  else
	      	action.poll_choices.create!({
	          label: poll_choice.label,
	          position: poll_choice.position
	        })
	       end
	    end
  	else
	  	poll = PollAction.new({
	      name: action.name
	    })
	    action.poll_choices.each do |poll_choice|
	      action.poll_choices.create!({
	          label: poll_choice.label,
	          position: poll_choice.position
	        })
	    end
	end

	return poll
  end
end
