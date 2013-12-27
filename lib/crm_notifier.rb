# See UserNotification module docs.
#
module CrmNotification

  module CrmNotifier
  
    # Sends a supporter to an external CRM. 
    #
    # @param notification_type The type of notification to send (as defined in UserNotification::Notifications)
    # @param params_hash A Hash of all info required for this notification (as defined in UserNotification::Notifications)
    #
    # return nothing, throw on any/all failures to notify
    # 
    def add_supporter(params_hash)
      raise NoMethodError.new "CRM Notification method not implemented!", __method__
    end

    def update_supporter(params_hash)
      raise NoMethodError.new "CRM Notification method not implement!", __method__
    end

    def delete_supporter(params_hash)
      raise NoMethodError.new "CRM Notification method not implmented", __method__
    end

    def get_supporter(params_hash)
      raise NoMethodError.new "CRM Notification method not implmented", __method__
    end
    
  end
  
end
