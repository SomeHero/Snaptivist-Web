# Service that sends user notifications via Exact Target emails.  
#
# See UserNotification module docs.
#
module CrmNotification

  require 'nationbuilder.rb'
  
  class NationBuilderCrmNotifier
    
    def create_or_update_supporter(user)
        begin
            
            NationBuilder.configure(
                :nation_name => "rva", 
                :client_id => "fca8f40ae0dba84cb81e8f4975b4759b4debeb4424c54e204105096a36d50a86",
                :client_secret => "22760ba29c759804929487f4fa935ac7744aa698700398a622fdb1d4edc0af14",
                :access_token => "ce97fd95b4a8a3b2003c00f5c30ccdcdb0710486509ea2b8acac0fd7f2336a2c",
                :redirect_uri => "http://localhost:3000/oauth_callback"
            )

            facebook = user.authentications.find_by_provider("facebook")
            
            result = NationBuilder::People.update_or_create({
                :external_id => user.id,
                :first_name => user.first_name,
                :last_name => user.last_name,
                :email => user.email,
                #:facebook_address => facebook ? "http://www.facebook.com/" + facebook.uid : nil,
                :tags => ["test1","test2"]
            })

          return result
        rescue => e
            Rails.logger.error e
        end

    end

    def delete_supporter(params_hash)
      raise NoMethodError.new "CRM Notification method not implmented", __method__
    end

    def get_supporter(params_hash)
      raise NoMethodError.new "CRM Notification method not implmented", __method__
    end

    def get_supporters()
        NationBuilder.configure(
            :nation_name => "rva", 
            :client_id => "fca8f40ae0dba84cb81e8f4975b4759b4debeb4424c54e204105096a36d50a86",
            :client_secret => "22760ba29c759804929487f4fa935ac7744aa698700398a622fdb1d4edc0af14",
            :access_token => "ce97fd95b4a8a3b2003c00f5c30ccdcdb0710486509ea2b8acac0fd7f2336a2c",
            :redirect_uri => "http://localhost:3000/oauth_callback"
        )

        NationBuilder::People.all


    end
    
  end
  
end
