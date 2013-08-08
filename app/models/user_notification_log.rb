class UserNotificationLog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :notification_type, :notification_uri, :sent, :test
end
