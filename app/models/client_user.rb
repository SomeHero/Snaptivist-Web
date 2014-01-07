class ClientUser < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
  # attr_accessible :title, :body
end
