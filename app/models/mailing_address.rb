class MailingAddress < ActiveRecord::Base
  attr_accessible :city, :email_address, :first_name, :last_name, :phone_number, :state, :street_address_1, :street_address_2, :string,, :zip_code
end
