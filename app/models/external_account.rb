class ExternalAccount < ActiveRecord::Base
  belongs_to :user
  attr_accessible :allowed_at, :authenticated_at, :email, :external_id, :type
end
