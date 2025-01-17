# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

require 'resque/server'
run Rack::URLMap.new \
  "/"       => SnaptivistWeb::Application,
  "/resque" => Resque::Server.new
