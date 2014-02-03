class FacebookServiceApi < SocialServiceApi
  @own_id = nil
  @own_profile = nil
  
  def fetch_own_id
    
    # We can cache this in our session once we get it once
    return @own_id if (@own_id)
    Rails.logger.debug "FBCALL Looking up user's own object..."
    @own_id = @koala.get_object('me')["id"]
    return @own_id    
  end

  def get_current_permissions()
    begin
      Rails.logger.debug "FBCALL Looking up user's own permissions..."
      perms = @koala.get_connections("me", 'permissions')
      Rails.logger.debug "Obtained FB permissions: #{perms}"
      #return (perms[0]["publish_stream"]) ? SocialServiceApi::PERMISSIONS_FULL : SocialServiceApi::PERMISSIONS_BASIC 
      return (perms[0]["email"]) ? SocialServiceApi::PERMISSIONS_FULL : SocialServiceApi::PERMISSIONS_BASIC
    rescue
    end
    SocialServiceApi::PERMISSIONS_NONE
  end

  def init_session_from_cookies(cookies)
    Rails.logger.debug "Looking for existing FB cookies..."
    begin
      facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
    rescue
    end
    if facebook_cookies
      Rails.logger.debug "  Found one!  Token is #{facebook_cookies['access_token']}."
      self.init_session(facebook_cookies['access_token'])
      return true
    else
      Rails.logger.debug "  none found, no active session."
      return false
    end
  end

  def init_session(token)
    @koala = Koala::Facebook::API.new(token)
    @token = token
  end

  def fetch_user_profile(user_id) 
    
    # If its our own, we can cache this once we get it once (it doesn't change within a given request)
    return @own_profile if (user_id == @own_id && @own_profile)
    Rails.logger.debug "FBCALL Looking up object..."
    #person = @koala.get_object('me')
    person = @koala.get_object(user_id)
    profile = person_to_profile(person)
    @own_profile = profile if user_id == @own_id 
    return profile
  end
  
  def get_token
    return @token
  end
  
  def recommended_friend_scheme
    return "birthday"
  end
 
  def publish_action(action, object, url, image_url = url)
    optional_args = {}
    optional_args[:message] = message unless message.blank?
    @koala.put_connections("me",
      "#{action}:#{object}",
      object.to_sym => url,
      "fb:explicitly_shared" => true,
      image => image_url)
  end

  def send_message(from, to, message, link = nil, caption = nil, description = nil, picture = nil, link_label = nil)
    return true
  end

  def service_name
    return "facebook"
  end

  def fetch_friends(include_self = false)

    unless @friend_profiles
      Rails.logger.debug "FBCALL Fetching user's friends..."
      friend_persons = @koala.get_connections("me", "friends", :fields => 'name,id,email,gender,age_range,birthday,political,location')
      @friend_profiles = Array.new()
      for person in friend_persons
        profile = person_to_profile(person)
        @friend_profiles << profile 
      end
      if (include_self)
        me = fetch_own_profile
        @friend_profiles << me
      end
      @friend_profiles.sort! {|a, b| a.name <=> b.name}
    end
    return @friend_profiles
  end
 
  def fetch_avatar_url(user_id)
    return "https://graph.facebook.com/#{user_id}/picture"
  end
  
  def fetch_profile_url(user_id)
    return "http://www.facebook.com/profile.php?id=#{user_id}"    
  end
  
  # General utility method to send a picture to a Facebook wall; not part of the Social Service interface
  #
  def util_send_wall_picture(picture_url = nil, message=nil, external_id = nil)
    begin
      FacebookAccount.api.put_picture(picture_url, {:message => message}, external_id)
    rescue Exception => e
      logger.error "ErrorEvent: For user #{user.name}: Failure to post picture to Facebook wall: error is #{e} #{e.backtrace}"
      return false
    end
    return true
  end
 
  # Utility method that sets restrictions on the Facebook app, not part of the generic social service api interface
  #
  def self.util_set_app_restrictions(restrictions)
    token = Koala::Facebook::OAuth.new.get_app_access_token
    api = Koala::Facebook::API.new(token)
    api.set_app_restrictions(Koala::Facebook::OAuth.new.app_id, restrictions)
  end

  private
  
  def person_to_profile(person)

    profile = NetworkProfile.new()
    profile.id = person["id"]
    profile.name = FacebookServiceApi.make_name(person)
    profile.first_name = person['first_name']
    profile.last_name = person['last_name']
    profile.avatars = NetworkProfile::AvatarSet.new()
    profile.avatars.set_all(fetch_avatar_url(profile.id))
    profile.url = fetch_profile_url(profile.id)
    profile.birth_date = person["birthday"] ? FacebookServiceApi.parse_date(person["birthday"]) : nil
    profile.email = person["email"]
    Rails.logger.debug "Generating Profile from Facebook person:"
    Rails.logger.debug "  Facebook person is: #{person.inspect}" 
    Rails.logger.debug "  Profile is: #{profile.inspect}" 
    return profile
  end

  # create a name from facebook parts
  def self.make_name(person)
    if person['first_name'] && person['last_name']
      return "#{person['first_name']} #{person['last_name']}"
    else
      return person['name']
    end
  end
  
  # parse Facebook Graph API date format
  def self.parse_date(d)
    if d.blank?
      return nil
    end
    
    # Put a year on if its just a day/month
    if d.split('/').length == 2
      d = d + '/1904'
    end
    
    # Parse
    begin
      return Date.strptime(d, '%m/%d/%Y')
    rescue => e
      Rails.logger.warn "Weird/bad/unparseable date format for FB fiend birthdate: #{d}" 
      return nil
    end
    return ret
  end
  
  def self.action_namespace
    env = Rails.env
    env = "dev" if env =~ /development/
    "treater-" + env.to_s
  end
end
