module SyncCrm
  @queue = :crm

  def self.perform(client_id, user_id)
    #now add the new user to configured CRM
    Rails.logger.debug "Syncing new user to CRM"

    client = Client.find(client_id)
    user = User.find(user_id)

    crm = CrmNotification::NationBuilderCrmNotifier.new
    result = crm.create_or_update_supporter(client.nation_builder_crm_authentication, user)

    if result
      user.external_id = result.id
      user.save!
    end

    puts "Sync'd user to crm"

  end
end