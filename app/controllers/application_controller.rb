class ApplicationController < ActionController::Base
  #protect_from_forgery

  def authenticate
    redirect_to :login unless User.find_by_provider_and_uid(auth["provider"], auth["uid"])
  end

  def current_client
    @client ||= Client.find(session[:client_id]) if session[:client_id]
    #@user ||= User.find_by_session_token!(cookies[:session_token]) if cookies[:session_token]
    @client
  end
  helper_method :current_user

  def sync_crm

    #now add the new user to configured CRM
    Rails.logger.debug "Syncing new user to CRM"

    crm = CrmNotification::NationBuilderCrmNotifier.new
    result = crm.create_or_update_supporter(@petition.client.nation_builder_crm_authentication, current_user)

    if result
      current_user.external_id = result.id
      current_user.save!
    end

  end

  def send_transaction_email

      config = @signature.petition.email_configurations.joins(:email_type).where(:email_types => { :id => 1 }).first

      if config && config.enabled
        if @signature.opt_in
        #send petition action email
          UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME, 
            :from_address => config.from_address,
            :from_name => config.from_name,
            :subject => config.subject,
            :user => current_user, 
            :template_name => config.email_template,
            :merge_fields => {
              "merge_petitiontitle" => @petition.title,
              "merge_firstname" => current_user.first_name,
              "merge_lastname" => current_user.last_name,
              #"merge_targetname" => petition.target.title + " " + petition.target.last_name,
              "merge_shorturl" => @petition.short_url,
              "merge_organizationname" => @petition.client.name,
              "merge_organizationavatar" => @petition.client.avatar("medium")
          })
        end
      end
  end

  def schedule_donation_reminder_email

      config = @signature.petition.email_configurations.joins(:email_type).where(:email_types => { :id => 2 }).first

      if config && config.enabled
        UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::DONATION_REMINDER,
            :from_address => config.from_address,
            :from_name => config.from_name,
            :subject => config.subject,
           :user => current_user, 
           :template_name => config.email_template,
           :merge_fields => {
            "merge_petitiontitle" => @petition.title,
            "merge_firstname" => current_user.first_name,
            "merge_lastname" => current_user.last_name,
            #"merge_targetname" => petition.target.title + " " + petition.target.last_name,
            "merge_shorturl" => @petition.short_url,
            "merge_organizationname" => @petition.client.name,
            "merge_organizationavatar" => @petition.client.avatar("medium")
        }, :time_offset_minutes => get_donation_reminder_email_time_offset)
      end

  end

  private

    def get_donation_reminder_email_time_offset
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
