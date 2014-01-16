module Nationbuilder
  @queue = :food

  def self.perform(client_id, payload)
      client = Client.find(client_id)
      
      webhook = CrmWebHook::NationBuilderCrmWebHook.new
      webhook.create_or_update_user(payload, client)

  end
end