class UserRawData < ActiveRecord::Base
  belongs_to :user
  belongs_to :raw_data
  # attr_accessible :title, :body
end
