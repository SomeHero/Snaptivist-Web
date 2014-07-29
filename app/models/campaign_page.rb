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

    if(self.action)
      self.action.update_attributes({
        name: action.name
      })
    else
      self.action = PetitionAction.new({
        name: action.name
      })
    end
  end

  def create_or_update_poll action

    if(self.action)
      self.action.update_attributes({
        name: action.name
      })
    else
      self.action = PollAction.new({
        name: action.name
      })
    end

    all_poll_choices = self.action.poll_choices.collect { |poll_choice| poll_choice.id }
    action.poll_choices.each do |poll_choice|
      if(poll_choice.id)
        all_poll_choices.delete(poll_choice.id)
        poll_choice = self.action.poll_choices.find(poll_choice.id)
      
        poll_choice.update_attributes({
          label: poll_choice.label,
          position: poll_choice.position
        })
      else
        self.action.poll_choices.new({
          label: poll_choice.label,
          position: poll_choice.position
        })
      end

    end

    all_poll_choices.each do |poll_choice_id|
      self.action.poll_choices.find(poll_choice_id).delete
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
