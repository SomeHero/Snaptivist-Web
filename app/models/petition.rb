require 'bitly'

class Petition < ActiveRecord::Base
  belongs_to :target
  belongs_to :user
  belongs_to :client
  has_many :signatures, :order => 'created_at DESC'
  has_many :petition_pages
  has_many :pages, :through => :petition_pages, :order => 'petition_pages.position'
  accepts_nested_attributes_for :petition_pages, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :email_configurations

  belongs_to :layout
  belongs_to :theme
  belongs_to :premium_offer

  has_many :premium_redemptions, :class_name => "PremiumGive"
  #validates :title, :presence => true
  #validates :summary, :presence => true
  #validates :target_count, :numericality => { :only_integer => true }

  accepts_nested_attributes_for :petition_pages
  accepts_nested_attributes_for :email_configurations
  accepts_nested_attributes_for :layout
  accepts_nested_attributes_for :theme
  
  has_attached_file :header_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    full: '782x271'
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"

  has_attached_file :footer_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    full: '782x271'
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"

  has_attached_file :signature_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    full: '782x271'
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"

  has_attached_file :delivery_image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    full: '782x271'
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"

  has_attached_file :premium_image, styles: {
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

    def share_count
      signatures.limit(nil).where("shared = true").count 
    end

    def delivery_count
      signatures.limit(nil).where("delivered = true").count
    end

    def premium_count
      premium_redemptions.count
    end

    def header_image_url
      header_image("full")
    end

    def footer_image_url      
      footer_image("full")
    end

    def signature_image_url
      signature_image("full")
    end

    def delivery_image_url
      delivery_image("full")
    end

    def premium_image_url
      premium_image("full")
    end

     # generate the petition
    def to_api

      results = {
        'petition_id' => id,
        'target_headline_text' => target_headline_text,
        'title' => title,
        'headline_primary' => headline_primary,
        'headline_secondary' => headline_secondary,
        'subheadline' => subheadline,
        'call_to_action_button_text' => call_to_action_button_text,
        'summary' => summary,
        'signature_headline_primary' => headline_primary,
        'signature_headline_secondary' => headline_secondary,
        'signature_subheadline' => subheadline,
        'signature_comment_placeholder_text' => signature_comment_placeholder_text,
        'sign_with_facebook_cta_button_text' => sign_with_facebook_cta_button_text,
        'sign_with_email_cta_button_text' => sign_with_email_cta_button_text,
        'signature_more_signers_button_text' => signature_more_signers_button_text,
        'delivery_headline_primary' => delivery_headline_primary,
        'delivery_headline_secondary' => delivery_headline_secondary,
        'delivery_subheadline' => delivery_subheadline,
        'delivery_call_to_action_text' => delivery_call_to_action_text,
        'delivery_call_to_action_button_text' => delivery_call_to_action_button_text,
        'delivery_skip_button_text' => delivery_skip_button_text,
        'delivery_more_tweets_button_text' => delivery_more_tweets_button_text,
        'premium_headline_primary' => premium_headline_primary,
        'premium_headline_secondary' => premium_headline_secondary,
        'premium_subheadline' => premium_subheadline,
        'premium_call_to_action_text' => premium_call_to_action_text,
        'premium_call_to_action_button_text' => premium_call_to_action_button_text,
        'premium_skip_button_text' => premium_skip_button_text,
        'default_tweet_text' => default_tweet_text,
        'tweet_cta_button_text' => tweet_cta_button_text,
        'signature_count' => signatures_count,
        'target_count' => target_count,
        'short_url' => short_url,
        'subdomain' => subdomain,
        'target' => target ? target.to_api : nil,
        'creator' => user ? user.to_api : nil,
        'client' => client ? client.to_api : nil,
        'comment' => comment,
        'premium_offer' => premium_offer ? premium_offer.to_api : nil,
        'donation_page_url' => donation_page_url,
        'created_at' => created_at,
        'updated_at' => updated_at,
        'signature_count' => signatures_count,
        'delivery_count' => 0,
        'share_count' => 0,
        'email_configurations' => email_configurations.map { |config| config.to_api },
        'layout' => layout ? layout.to_api : nil,
        'theme' => theme ? theme.to_api : nil,
        'pages' => pages.map { |page| page.to_api },
        'disclaimer_text' => disclaimer_text
      }

      Petition::IMAGE_SIZES.each do |label, size|
        if header_image_file_name
          results["header_image_#{label}_url"] = header_image(label)
        end
      end

      Petition::IMAGE_SIZES.each do |label, size|
        if footer_image_file_name
          results["footer_image_#{label}_url"] = footer_image(label)
        end
      end

      Petition::IMAGE_SIZES.each do |label, size|
        if signature_image_file_name
          results["signature_image_#{label}_url"] = signature_image(label)
        end
      end

      Petition::IMAGE_SIZES.each do |label, size|
        if delivery_image_file_name
          results["delivery_image_#{label}_url"] = delivery_image(label)
        end
      end

      Petition::IMAGE_SIZES.each do |label, size|
        if premium_image_file_name
          results["premium_image_#{label}_url"] = premium_image(label)
        end
      end

      return results;

    end
  
end
