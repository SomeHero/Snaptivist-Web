# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SnaptivistWeb::Application.initialize!

OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'SSLv3' 
