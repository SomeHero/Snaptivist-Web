module SignatureEmailProcessor
  @queue = :email_processor

  def self.perform(petition_id, signature_id)
    petition = Petition.find(petition_id)
    signature = petition.signatures.find(signature_id)
 
    self.send_transaction_email petition, signature
    self.schedule_donation_reminder_email petition, signature

    puts "Processed Signature Emails"

  end

  def self.send_transaction_email petition, signature

        config = signature.petition.email_configurations.joins(:email_type).where(:email_types => { :id => 1 }).first

        if config && config.enabled
          if signature.opt_in
          #send petition action email
            UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME, 
              :from_address => config.from_address,
              :from_name => config.from_name,
              :subject => config.subject,
              :user => signature.user, 
              :template_name => config.email_template,
              :merge_fields => {
                "merge_petitiontitle" => petition.title,
                "merge_firstname" => signature.user.first_name,
                "merge_lastname" => signature.user.last_name,
                #"merge_targetname" => petition.target.title + " " + petition.target.last_name,
                "merge_shorturl" => petition.short_url,
                "merge_organizationname" => petition.client.name,
                "merge_organizationavatar" => petition.client.avatar("medium"),
                "merge_disclaimertext" => petition.disclaimer_text
            })
          end
        end
    end

    def self.schedule_donation_reminder_email petition, signature

        config = signature.petition.email_configurations.joins(:email_type).where(:email_types => { :id => 2 }).first

        if config && config.enabled
          UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::DONATION_REMINDER,
              :from_address => config.from_address,
              :from_name => config.from_name,
              :subject => config.subject,
             :user => signature.user, 
             :template_name => config.email_template,
             :merge_fields => {
              "merge_petitiontitle" => petition.title,
              "merge_firstname" => signature.user.first_name,
              "merge_lastname" => signature.user.last_name,
              #"merge_targetname" => petition.target.title + " " + petition.target.last_name,
              "merge_shorturl" => petition.short_url,
              "merge_organizationname" => petition.client.name,
              "merge_organizationavatar" => petition.client.avatar("medium"),
              "merge_disclaimertext" => petition.disclaimer_text
          }, :time_offset_minutes => get_donation_reminder_email_time_offset)
        end

    end

    def self.get_donation_reminder_email_time_offset
      #we will send all donation email at 6 am the next day unless
      #the difference is less than 6 hours between signature and send time
      #then we will add 24
      #we should look into timezone 
      #we should make the send time configurable
      send = (Date.tomorrow.beginning_of_day() + 6.hours)
      now = DateTime.now

      difference_in_hours = (send - now)/3600

      difference_in_hours += 24 if difference_in_hours < 6

      return difference_in_hours*60

    end

end