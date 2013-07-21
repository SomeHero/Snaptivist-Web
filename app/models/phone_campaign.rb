class PhoneCampaign < ActiveRecord::Base
  belongs_to :target
  belongs_to :user
  has_many :call_results

  validates :title, :presence => true
  validates :summary, :presence => true
  validates :target_count, :numericality => { :only_integer => true }
  
  has_attached_file :header_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    full: '782x271'
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"

  IMAGE_SIZES = {"thumb" => "100x100",
                "square" => "200x200#",
                "medium" => "300x300",
                "full" => "782x271"}

  before_create :shorten_url

  def shorten_url

    Bitly.use_api_version_3
    
    bitly = Bitly.new('jrhodes621', 'R_097da24e7dfc44e6b422cd74b41a353e');

    long_url = 'http://dev.snaptivist.com/phonecampaigns/' + id.to_s

    url = bitly.shorten(long_url)

    return url.short_url

  end

   # generate the petition
  def to_api

    results = {
      'phonecampaign_id' => id,
      'title' => title,
      'summary' => summary,
      'target_count' => target_count,
      'call_results_count' => call_results_count,
      'short_url' => short_url,
      'rewrite_url_key' => rewrite_url_key,
      'target' => target.to_api,
      'creator' => user.to_api,
      'comment' => 'test',
      'created_at' => created_at,
      'updated_at' => updated_at,
    }

    PhoneCampaign::IMAGE_SIZES.each do |label, size|
      if header_image_file_name
        results["image_#{label}"] = header_image(label)
      end
    end

    return results;

  end
end
