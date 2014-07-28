require 'bitly'

class Campaign < ActiveRecord::Base
  belongs_to :client
  belongs_to :layout
  belongs_to :theme
  
  has_many :campaign_pages, :order => "position ASC"
  has_many :pages, :through => :campaign_pages, :order => 'campaign_pages.position'
  
  has_many :campaign_urls
  has_many :urls, :through => :campaign_urls

  has_many :user_campaign_actions

  has_many :email_configurations

  attr_accessible :subdomain, :title, :client, :page_attributes, :pages

  accepts_nested_attributes_for :campaign_pages, :reject_if => :all_blank, :allow_destroy => true
  
  after_create :create_short_url

  def to_api

    results = {
      'id' => id,
      'title' => title,
      'subdomain' => subdomain,
      'pages' => campaign_pages.map { |campaign_page| campaign_page.to_api }
    }

    return results;

  end

  private 

    def create_short_url

      Bitly.use_api_version_3
      
      bitly = Bitly.new('jrhodes621', 'R_097da24e7dfc44e6b422cd74b41a353e');

      long_url = Settings.protocol + self.subdomain + "." + Settings.path + '/Campaigns/' + self.id.to_s

      url = bitly.shorten(long_url)

      self.urls.create!({
          address: url.short_url
      })

    end

end
