class Action < ActiveRecord::Base
  attr_accessible :subdomain, :title, :type
end
