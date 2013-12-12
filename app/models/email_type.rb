class EmailType < ActiveRecord::Base
  attr_accessible :default_email_template, :description, :name
end
