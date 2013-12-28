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
      
      result = ""
      case notification_type
      when UserNotification::Notification::USER_WELCOME  
        user = params_hash[:user]

        template_name = params_hash[:template_name] || "PetitionSignature"
        #subject = "You just signed a petition using Snaptivist."
        from_address = params_hash[:from_address] || Settings.default_from
        from_name = params_hash[:from_name]|| Settings.default_from_name
        subject = params_hash[:subject] ||  "Your petition signature"

        merge_fields = params_hash[:merge_fields]
        result = ElasticEmailApi.send_email(user.email, subject, template_name, from_address, from_name, merge_fields)
      when UserNotification::Notification::SIGNATURE_CONFIRMATION 
        user = params_hash[:user]
        template_name = "Signature Confirmation"
        subject = "Your petition signature"

        merge_fields = params_hash[:merge_fields]
        result = ElasticEmailApi.send_email(user.email, subject, template_name, Settings.default_from, Settings.default_from_name, merge_fields)
      when UserNotification::Notification::SIGNATURE_DELIVERY_REMINDER
        user = params_hash[:user]
        template_name = "Delivery Follow Up"
        subject = "Your Message Wasn't Delivered"

        merge_fields = params_hash[:merge_fields]
        result = ElasticEmailApi.send_email(user.email, subject, template_name, Settings.default_from, Settings.default_from_name, merge_fields)
      when UserNotification::Notification::DONATION_REMINDER
        user = params_hash[:user]
        template_name = params_hash[:template_name] || "Test Donation Reminder Email"
        subject = params_hash[:subject] || "Donation Reminder Email"
        time_offset_minutes = params_hash[:time_offset_minutes]

        merge_fields = params_hash[:merge_fields]
        result = ElasticEmailApi.send_email(user.email, subject, template_name, Settings.default_from, Settings.default_from_name, merge_fields,
          "", "", "", time_offset_minutes)
      else
          raise "I don't know how to handle notifications of type '#{notification_type}'!"
      end
      Rails.logger.debug 'ElasticEmail result: ' + result

    end

    # For a user that we only have an email address for, get a subscriber ID we can use for them.
    
  end
  
end

