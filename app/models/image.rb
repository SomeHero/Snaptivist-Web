class Image < ActiveRecord::Base
  attr_accessible :photo

  has_attached_file :photo, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '600x150>',
    full: '1200x300>'
  },
  :url => ':s3_domain_url',
  :path => "/:class/:id/:style_:filename"


  IMAGE_SIZES = {"thumb" => "100x100",
            "square" => "200x200",
            "medium" => "600x150",
            "full" => "1200x300"
       }
  do_not_validate_attachment_file_type :photo

  def get_sizes

    results = {}

      Image::IMAGE_SIZES.each do |label, size|
        if photo
          results["#{label}"] = photo(label)
        end
      end

      return results;

  end

  def to_api

      results = {}

      Image::IMAGE_SIZES.each do |label, size|
        if photo
          results["image_#{label}_url"] = photo(label)
        end
      end

      return results;

   end

end
