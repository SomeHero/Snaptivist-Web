class NationBuilderCrmAuthentication < ActiveRecord::Base
	has_one :client
  
  attr_accessible :access_token, :client_app_id, :client_id, :client_secret, :nation_name, :redirect_uri
end
