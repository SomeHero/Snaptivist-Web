# Defines a basic namespace for all user notification services. The system works as follows:
#
#  * There is a set of defined UserNotification constants that represent the set of logical notifications 
#    that the app can send to users
#    * Each of these is identified by a string "type" name, and each type defines a set of relevant 
#      parameters needed when sending
#  * A Channel is a communications means on which the app can send notifications
#  * Individual UserNotifier objects are responsible for formatting and sending notifications to users on 
#    whatever Channel they know how to communicate on 
#  * There is a UserNotificationRouter that is responsible for managing which notifiers are hooked up for
#    which "channels", and thorugh which the application triggers all notifications.
#    * Eventually, the UserNotificationRouter could maintain per-user preferences for sms vs email and things
#      of that nature 
#  * All sent (or failed) user notifciations are cleanly logged in the user_notification_xactions table
#
# To use the system from the application, see UserNotification::UserNotificationRouter.
#
module UserNotification

  # Suck in the bulk of th emodule
  require 'user_notifier.rb'
  require 'user_notification_router.rb'

  # Notification logical types. These are constants mapped to symbols for use in logging and hashing.
  #
  module Notification

    # Provide the user with a link from which to download the native app. Params:
    #   :url => The download link
    #   :email => The email address to which to send the link, if any
    #   :phone => The phone # to which to send the invite, if any
    APP_LINK = :app_link

    # Send a user an invitation to the system. Params:
    #   :inviter => The User doing the inviting
    #   :invitee_email => The email address to which to send the invite, if any
    #   :invitee_phone => The phone # to which to send the invite, if any
    #   :message => A custom message to include with the invite
    USER_INVITE = :user_invite
  
    # Welcome a new user to the application. Params:
    #   :user => The User we are welcoming
    USER_WELCOME = :user_welcome

    # Confirmation email to a petition signer. Params:
    #   :user => The User we are welcoming
    SIGNATURE_CONFIRMATION = :signature_confirmation

    # Signature delivery reminder.
    # Params 
    # :user => The user that signed the petition
    # :client => The client who is sponsoring the petition
    # :petition => The petition
    # :signature => The signature
    SIGNATURE_DELIVERY_REMINDER = :signature_delivery_reminder
    DONATION_REMINDER = :donation_reminder

  end

  # Notification channel types
  module Channel
    EMAIL = :email
    TEXT = :text
    APP = :app
  end
  
end
