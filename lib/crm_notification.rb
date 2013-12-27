# Defines a basic namespace for all crm notification services. The system works as follows:
#
#  * There is a set of defined UserNotification constants that represent the set of logical notifications 
#    that the app can send to users
#  * Each of these is identified by a string "type" name, and each type defines a set of relevant 
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