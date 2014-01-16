require 'hipchat-api'

module Hipchat
  @queue = :hipchat

  def self.perform(petition, signature)
    hipchat_api = HipChat::API.new('41115733635e0917d7debfc51848c4')

    room_id = "Snaptivist"
    from = "SnapMon"

    user = User.find(signature["user_id"])
    message = user.first_name + " " + user.last_name + " (" + user.email + ") just signed the petition " + petition["title"] + ".  The petition has been signed " + petition["signatures_count"].to_s + " times."

    hipchat_api.rooms_message(room_id, from, message, notify = 0, color = 'yellow', message_format = 'html')
    puts "Posted message to HipChat!"
  end

end