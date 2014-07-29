class EmailQueue < ActiveRecord::Base
  belongs_to :signature
  belongs_to :email_type
  #attr_accessible :sent, :sent_at
end
