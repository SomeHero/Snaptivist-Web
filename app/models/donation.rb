class Donation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :amount, :cancelled_date, :donation_status, :source, :string, :submitted_date
end
