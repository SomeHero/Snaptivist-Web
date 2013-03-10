class Petition < ActiveRecord::Base
  belongs_to :target
  attr_accessible :rewrite_url_key, :short_url, :summary, :target_count, :title
  validates :title, :presence => true
  validates :summary, :presence => true
  validates :target_count, :numericality => { :only_integer => true }
end
