class CampaignPage < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :page
  belongs_to :action

  has_many :campaign_page_urls
  has_many :urls, :through => :campaign_page_urls

  #attr_accessible :campaign_id, :page_id, :position, :action

  after_create :create_short_url

  def to_api

    results = {
      'page_id' => id,
      'position' => position,
      'action' => action ? action.to_api : nil,
      'page' =>  page ? page.to_api : nil
     }
    return results;

  end

  def get_content
    result = {}
    if(self.id)
      json = self.content

      if(json)
        result = JSON.parse(json)
      end

    end

    return result
  end

  def get_action
    return action ? action.to_api : {}
  end

  def create_or_update_petition action

    parameters = ActionController::Parameters.new(action)
    params = parameters.permit(:name)

    if(self.action)
      self.action.update(params)
    else
      self.action = PetitionAction.create(params)
    end
  end

  def create_or_update_tweet action

    parameters = ActionController::Parameters.new(action)
    params = parameters.permit(:name)

    if(self.action)
      self.action.update(params)
    else
      self.action = TweetAction.create(params)
    end
  end

  def create_or_update_premium action

    parameters = ActionController::Parameters.new(action)
    params = parameters.permit(:name)

    if(self.action)
      self.action.update(params)
    else
      self.action = PremiumAction.create(params)
    end
  end

  def create_or_update_donation action

    parameters = ActionController::Parameters.new(action)
    params = parameters.permit(:name)

    if(self.action)
      self.action.update(params)
    else
      self.action = DonationAction.create(params)
    end
  end

  def create_or_update_poll action

    parameters = ActionController::Parameters.new(action)
    params = parameters.permit(:name, :poll_choices_attributes => [:id, :label, :position, :_destroy])

    if(self.action)
      self.action.update(params)
    else
      self.action = PollAction.create(params)
    end
  
  end

  def create_or_update_poll_results action

    parameters = ActionController::Parameters.new(action)
    params = parameters.permit(:name)

    poll = PollAction.find(parameters[:poll_id])
    
    if(self.action)
      self.action.update(params)
    else
      self.action = PollResultAction.create({
        poll: poll
      })
    end
  

  end


  def create_short_url

    Bitly.use_api_version_3
    
    bitly = Bitly.new('jrhodes621', 'R_097da24e7dfc44e6b422cd74b41a353e');

    long_url = Settings.protocol + self.campaign.subdomain + "." + Settings.path + '/Campaigns/' + self.campaign.id.to_s + '/pages/' + self.id.to_s

    url = bitly.shorten(long_url)

    self.urls.create!({
        address: url.short_url
    })

  end

end
