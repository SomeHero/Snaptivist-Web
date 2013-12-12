class EmailConfiguration < ActiveRecord::Base
  belongs_to :email_type
  belongs_to :client
  attr_accessible :email_template, :from_address, :from_name, :last_id_sent, :subject
end
