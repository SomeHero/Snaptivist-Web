require 'net/http'
require 'uri'

USERNAME = 'james@snaptivist.com' 
API_KEY = '9a97db59-3bf2-4034-9375-882841679dfe' 
API_URI = URI.parse( 'http://api.elasticemail.com/mailer/send' )
SUCCESS_MATCH_PATTERN = '^[0-9|a-f]{8}-[0-9|a-f]{4}-[0-9|a-f]{4}-[0-9|a-f]{4}-[0-9|a-f]{12}$' 
ERROR_MATCH_PATTERN = '^Error:' 

class ElasticEmailApi

	class << self

		def send_email(to_addr, subject, template_name, from_addr, from_name, merge_fields, reply_to_email=nil, reply_to_name=nil, channel=nil )
			Rails.logger.debug 'Attempting to post to Elastic Email'

			msg_info = { 
				'username' => USERNAME,
				'api_key' => API_KEY,
				'from' => from_addr,
				'from_name' => from_name,
				'to' => to_addr,
				'subject' => subject,
				'template' => template_name,
				'reply_to' => reply_to_email,
				'reply_to_name' => reply_to_name,
				'channel' => channel 
			}
			merge_fields.each do |key,value| 
				msg_info[key] = value 
			end

			Rails.logger.debug msg_info

			begin
				Net::HTTP.post_form(API_URI, msg_info).body
			rescue StandardError => e
				e.message
			end
		end

	end

end