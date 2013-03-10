class ExternalAccount < ActiveRecord::Base
  belongs_to :user
  attr_accessible :allowed_at, :authenticated_at, :email, :external_id, :type

    # default external account has no avatar
  def avatar_url
    return ''
  end
  
  # default profile URL has no profile
  def profile_url
    return ''
  end
  
  # default service name is nothing
  def service_name
    return 'Unknown'
  end
  
end
