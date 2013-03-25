class PhoneCampaign < ActiveRecord::Base
  belongs_to :target
  belongs_to :user

  attr_accessible :rewrite_url_key, :short_url, :summary, :target_count, :title

   validates :title, :presence => true
  validates :summary, :presence => true
  validates :target_count, :numericality => { :only_integer => true }

   # generate the petition
  def to_api

    results = {
      'phonecampaign_id' => id,
      'title' => title,
      'summary' => summary,
      'target_count' => target_count,
      'short_url' => short_url,
      'rewrite_url_key' => rewrite_url_key,
      'target' => target.to_api
    }

    return results;

  end
end
