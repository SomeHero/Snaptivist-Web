# Represents the basic set of information about a user's presence on a social network.
#
# The only fields that are guaranteed to not be null are name and id, the others are gravy.
# 
class NetworkProfile

  class AvatarSet
    
    attr_accessor :default, :small, :normal, :large    
    
    def set_all(avatar_url)
      @default = avatar_url
      @small = @default
      @normal = @default
      @large = @default
    end
    
  end
  
  attr_accessor :name, :first_name, :last_name, :id, :email, :birth_date, :url, :avatars, :location_friendly    
  
end
