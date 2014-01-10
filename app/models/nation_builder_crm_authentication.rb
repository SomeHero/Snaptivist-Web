class NationBuilderCrmAuthentication < ActiveRecord::Base
	has_one :client
  
    attr_accessible :client, :access_token, :client_app_id, :client_id, :client_secret, :nation_name, :redirect_uri

	def to_api

      results = {
        'nation_name' => nation_name,
        'client_app_id' => client_app_id,
        'client_secret' => client_secret,
        'redirect_uri' => redirect_uri
       }
       
    end
end
