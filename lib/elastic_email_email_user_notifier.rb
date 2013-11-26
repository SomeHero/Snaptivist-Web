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
      binding.pry
      result = ""
      case notification_type
      when UserNotification::Notification::USER_WELCOME  
        user = params_hash[:user]
        template_name = "PetitionSignature"
        subject = "You just signed a petition using Snaptivist."

        merge_fields = params_hash[:merge_fields]
        result = ElasticEmailApi.send_email(user.email, subject, template_name, Settings.default_from, Settings.default_from_name, merge_fields)
      when UserNotification::Notification::SIGNATURE_CONFIRMATION 
        user = params_hash[:user]
        template_name = "Signature Confirmation"
        subject = "You just signed a petition using Snaptivist."

        merge_fields = params_hash[:merge_fields]
        result = ElasticEmailApi.send_email(user.email, subject, template_name, Settings.default_from, Settings.default_from_name, merge_fields)
      when UserNotification::Notification::SIGNATURE_DELIVERY_REMINDER
        user = params_hash[:user]
        template_name = "Delivery Follow Up"
        subject = "Your Message Wasn't Delivered"

        merge_fields = params_hash[:merge_fields]
        result = ElasticEmailApi.send_email(user.email, subject, template_name, Settings.default_from, Settings.default_from_name, merge_fields)
      else
          raise "I don't know how to handle notifications of type '#{notification_type}'!"
      end
      Rails.logger.debug 'ElasticEmail result: ' + result

    end

    # For a user that we only have an email address for, get a subscriber ID we can use for them.
    
  end
  
end

