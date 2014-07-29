class Poll < ActiveRecord::Base
  #attr_accessible :question, :rewrite_url_key, :short_url, :user_id,  :subdomain, :comment
  belongs_to :user
  has_many :choices

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

  def shorten_url

    Bitly.use_api_version_3
    
    bitly = Bitly.new('jrhodes621', 'R_097da24e7dfc44e6b422cd74b41a353e');

    long_url = 'http://dev.snaptivist.com/polls/' + id.to_s

    url = bitly.shorten(long_url)

    return url.short_url

  end

  # generate the poll
  def to_api

    results = {
      'poll_id' => id,
      'question' => question,
      'short_url' => short_url,
      'rewrite_url_key' => rewrite_url_key,
    }
    results[:choices] = []

    self.choices.each do |choice|
        results[:choices] << choice.to_api()
    end
    
    return results;

  end
end
