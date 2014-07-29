class PollChoice < ActiveRecord::Base
  belongs_to :poll_action

  #attr_accessible :id, :label, :position

  def to_api

    results = {
      'id' => id,
      'label' => label,
      'position' => position
    }

    return results;
  end

  def get_count
    return UserCampaignVoteAction.where(:poll_choice_id => self.id).count
  end

  def get_percentage
    if(poll_action.get_count == 0)
      return 0
    else
      return get_count.to_f/poll_action.get_count.to_f
    end
  end

end
