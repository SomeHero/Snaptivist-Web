require 'bitly'

class Petition < ActiveRecord::Base
  belongs_to :target
  belongs_to :user
  has_many :signatures, :order => 'created_at DESC', :limit => 10
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

  private 
    def shorten_url

      Bitly.use_api_version_3
      
      bitly = Bitly.new('jrhodes621', 'R_097da24e7dfc44e6b422cd74b41a353e');

      long_url = Settings.protocol + self.subdomain + "." + Settings.path

      url = bitly.shorten(long_url)

      self.short_url = url.short_url

    end

  public
    # get URL to image of a specific size
    def p_image_url(label = nil, use_pre_publish = false)
      if use_pre_publish && !p_pre_publish_image_file_name.blank?
        if label.nil?
          p_pre_publish_image.url
        else
          p_pre_publish_image.url(label)
        end
      elsif p_image_file_name.blank?
        Product.default_image(label)
      elsif label.nil?
        p_image.url
      else
        p_image.url(label)
      end
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
        'creator' => user.to_api,
        'comment' => comment,
        'created_at' => created_at,
        'updated_at' => updated_at,
      }

      Petition::IMAGE_SIZES.each do |label, size|
        if header_image_file_name
          results["image_#{label}"] = header_image(label)
        end
      end

      return results;

    end
  
end
