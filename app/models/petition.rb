require 'bitly'

class Petition < ActiveRecord::Base
  belongs_to :target
  belongs_to :user
  has_many :signatures, :order => 'created_at DESC', :limit => 10
  validates :title, :presence => true
  validates :summary, :presence => true
  validates :target_count, :numericality => { :only_integer => true }

  def shorten_url

    Bitly.use_api_version_3
    
    bitly = Bitly.new('jrhodes621', 'R_097da24e7dfc44e6b422cd74b41a353e');

    long_url = 'http://dev.snaptivist.com/petitions/' + id.to_s

    url = bitly.shorten(long_url)

    return url.short_url

  end

   # generate the petition
  def to_api

    results = {
      'petition_id' => id,
      'title' => title,
      'summary' => summary,
      'signature_count' => signatures_count,
      'target_count' => target_count,
      'short_url' => short_url,
      'rewrite_url_key' => rewrite_url_key,
      'target' => target.to_api,
      'creator' => user.to_api
    }

    return results;

  end
  
end
