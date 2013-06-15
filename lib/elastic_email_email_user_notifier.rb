# Service that sends user notifications via Exact Target emails.  
#
# See UserNotification module docs.
#
module UserNotification

  require 'elastic_email_api.rb'
  
  class ElasticEmailEmailUserNotifier
    
    include UserNotifier

    def send_notification(notification_type, params_hash)
      Rails.logger.debug "ElasticEmailUserNotififer attempting to send '#{notification_type}' notification using params: #{params_hash.inspect}"
      case notification_type
      when UserNotification::Notification::USER_WELCOME  
        user = params_hash[:user]
        template_name = "NewUser"
        subject = "You just signed a petition using Snaptivist."

        ElasticEmailApi.send_email(user.email, subject, template_name, Settings.default_from, Settings.default_from_name)
      else
          raise "I don't know how to handle notifications of type '#{notification_type}'!"
      end
    end

    # For a user that we only have an email address for, get a subscriber ID we can use for them.
    
  end
  
end
