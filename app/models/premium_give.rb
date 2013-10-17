class PremiumGive < ActiveRecord::Base
  belongs_to :user
  belongs_to :signature
  belongs_to :mailing_address
  # attr_accessible :title, :body
end
