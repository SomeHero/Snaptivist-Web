# An API interface to a Social Service. A service is something that:
# - supports the notion of user profiles and identities (accessed via an ExternalAccount)
# - provide basic info about individual users
# - provide "friends" to whom a user can send treats
# - offer a way for the giver to send a message to the receiver
#
# TODO 
# - thank you messages?
# - internal caching? or above? profile-cache utility for use by all?
# - better tie to ExtrnalAccount and Authenticator?
#
class SocialServiceApi

  PERMISSIONS_NONE = 0
  PERMISSIONS_BASIC = 1
  PERMISSIONS_FULL = 2
  
  @@sessions = Hash.new()
  
  # Obtain an active API session to the specified service, using the token info (whatever that is) provided
  # during appropriately-executed prior authentication steps.
  #
  # @service_name the name of the service
  # @token the token to use to start the session
  #
  # @return A SocialServiceApi instance, ready for use
  #
  def self.init_api_session(service_name, token) 
    api = SocialServiceApi.init_api_sessionless(service_name)
    Rails.logger.debug "Initializing session with token: #{token.inspect}..."
    api.init_session(token)
    @@sessions[service_name] = api
    Rails.logger.debug "Api session started."
    return api
  end

  # Obtain a sessionless API to the specified service, which can only be used for limited things (things that don't require sessions).  
  # Usually, callers will want init_api_session
  #
  # @service_name the name of the service
  #
  # @return A SocialServiceApi instance, ready for use
  #
  def self.init_api_sessionless(service_name)
    Rails.logger.debug "Attempting to load api for service '#{service_name}'..."
    api_class = ClassLoader.get_class(service_name, "ServiceApi")
    Rails.logger.debug "Api class loaded, Api available."
    api = api_class.new()
    return api
  end
  
  # End an active API session
  #
  def self.end_api_session(service_name) 
    Rails.logger.debug "Attempting to end api session for service '#{service_name}'..."
    if (@@sessions[service_name]) 
      @@sessions[service_name].end_session
      @@sessions[service_name] = nil
      Rails.logger.debug "Session ended"
    else
      Rails.logger.debug "Didn't have an active session to end."
    end
  end

  # Check request cookies to see if there are possibly any active sessions there
  #
  def self.get_api_session_from_cookies(cookies)
    known_services.each do | service_name |
      api_class = ClassLoader.get_class(service_name, "ServiceApi")
      Rails.logger.debug "Api class loaded, checking if it has a session once it sees the request cookies..."
      api = api_class.new()
      if (api.init_session_from_cookies(cookies))
        return api
      end   
    end
    return nil
  end
  
  def self.known_services()
    return ["linked_in", "twitter", "facebook"]
  end
     
  # Obtain an instance of an active api session with the given service.
  #
  # @param allow_sessionless If you know that you will use the API ONLY for things that do not actually need an active session (rare)...
  # 
  # @return the session, raise if none active
  # 
  def self.get_api_session(service_name, allow_sessionless=false)
    if (!@@sessions[service_name])
    
      # No active session...usually bad, but a user might want sessionless
      if (allow_sessionless)
        return SocialServiceApi.init_api_sessionless(service_name) 
      else
        raise "No session active with '#{service_name}'"
      end
    end
    return @@sessions[service_name]
  end
  
  # Wrapper for fetch_friends that introduces a caching layer. We'll cache the user's list of friends, and the profiles of those friends, 
  # per user. TODO we can share cached profiles probably, to reduce cache space and lookup times.
  #
  # @param sapi the api instance (active session)
  # @user_id the ID of the user whose friends we're getting (so we can key the cache)
  #
  def self.fetch_friends_cacheable(sapi, user_id, include_self = false)
    friend_ids_key_prefix = "friend_id_lists/#{user_id}/#{sapi.service_name}"
    friend_profiles_key_prefix = "friend_profiles/#{user_id}/#{sapi.service_name}"
    
    # look in the cache for a stored set of friend IDs
    friend_ids = get_cached_data(friend_ids_key_prefix, Settings.friends_cache_hours)
    friend_profiles = get_cached_data(friend_profiles_key_prefix, Settings.friends_cache_hours)
    if (!friend_ids || !friend_profiles) 
      
      # no cached friend IDs, go get the friends
      Rails.logger.debug "This user's friends list isn't cached, go fetch it from the service..."
      friends = sapi.fetch_friends(include_self)
      
      # Build up the ID list and cache that 
      Rails.logger.debug "Caching user's friends' IDs..."
      friend_ids = friends.collect do |network_profile|
        network_profile.id
      end
      put_cached_data(friend_ids_key_prefix, friend_ids, Settings.friends_cache_hours)  
      
      # Now cache the full set of NetworkProfiles (we may eventually stop doing this)
      Rails.logger.debug "Caching user's friends' objects..."
      put_cached_data(friend_profiles_key_prefix, friends, Settings.friends_cache_hours)  
      
      # Ok, now everything is cached, return it all
      Rails.logger.debug "User's friends data now cached, returning it."
      return friends
    else
      
      # Cool, friends list is cached...
      Rails.logger.debug "User's friends data appears to be cached, returning it."
      friends = get_cached_data(friend_profiles_key_prefix, Settings.friends_cache_hours)
      return friends
    end
  end
  
  # Stores data in the cache using the standard fetchtime/data pairing.  Use get_cached_data to get it back.
  #
  def self.put_cached_data(key_prefix, data, cache_hours)
    fetchtime_key = "#{key_prefix}/fetch_time"
    data_key = "#{key_prefix}/data"
    fetchtime = Time.now
    Rails.logger.debug "Writing data to cache at keys under #{key_prefix}"
    Rails.cache.write fetchtime_key, fetchtime, :expires_in => cache_hours.to_i.hours
    Rails.cache.write data_key, data
  end
  
  # Given a standard fetchtime/data pair at a given key prefix, returns the data if its available and valid according to the cache time
  #
  # @return cached data object or nil 
  #
  def self.get_cached_data(key_prefix, cache_hours)
    fetchtime_key = "#{key_prefix}/fetch_time"
    data_key = "#{key_prefix}/data"
    fetchtime = Rails.cache.read fetchtime_key
    data = Rails.cache.read data_key
    #Rails.logger.debug "Checking cache for #{key_prefix}--> " + (fetchtime ? "last fetched at #{fetchtime}" : "no previous fetchtime") + ",  " + (data ? "data object set" : "no data available")
    if (fetchtime)
      expiretime = fetchtime + cache_hours.to_i.hours
      #Rails.logger.debug "We have data from #{fetchtime}, its good until #{expiretime}..."
      if (fetchtime < expiretime)
        #Rails.logger.debug "We can use the cached data..."
        return data
      end  
    end
    #Rails.logger.debug "No usable cached data is available..."
    return nil
  end
  
  # Determines the current permissions available via the service session, and also serves to validate the session.
  #
  # @return the permissions level, PERMISSIONS_NONE if the session has none and isn't valid, basically
  #
  def get_current_permissions()
    SocialServiceApi::PERMISSIONS_NONE
  end
  
  # Determine the maximum allowable length of the user-generated part of the gift message, suitable for use in the UI.
  #
  def gift_message_max_length
    raise "Method not implemented!"
  end
  
  # Preview the gift message that will be sent to the receiver, suitable for use in the UI.
  #
  def gift_message_preview(sender_external_id, receiver_external_id)
    raise "Method not implemented!"
  end
  
  def service_name
    raise "Method not implemented!"
  end

  def get_token
    raise "Method not implemented!"
  end
  
  # Load the NetworkProfiles of the "friends" of the user whom the API session is in the contet of.
  #
  # @return Array of NetworkProfile objects, raise if error
  #
  def fetch_friends(include_self = false)
    raise "Method not implemented!"
  end

  # End this active session.
  # 
  def end_session
    Rails.logger.info "Ending service session (just a NOOP)."
  end
  
  # Load the NetworkProfile of the specified user.
  #
  # @return The NetworkProfile, nil if we don't know this user 
  #
  def fetch_user_profile(user_id)
    raise "Method not implemented!"
  end 

  # Load the NetworkProfile of the user whom the current API session is in the context of.
  #
  # @return The NetworkProfile, raise if error
  #
  def fetch_own_profile
    
    # Make sure we have our own ID (TODO just get this from our token)
    Rails.logger.debug "Fetching user's own ID..."
    id = fetch_own_id
    
    # Now get the basic profile info
    Rails.logger.debug "Fetching user's own profile..."
    profile = fetch_user_profile(id)
    return profile
  end

  def fetch_avatar_url(user_id)
    Rails.logger.warn "Attempting to fetch avatar URL, service doesn't have this implemented!"
    return '/assets/icon_no_image.png'
  end
    
  def fetch_profile_url(user_id)
    Rails.logger.warn "Attempting to fetch profile URL, service doesn't have this implemented!"
    raise "Requesting profile url for service that doesn't have one (why?)"
  end
  
  def send_message(from, to, message, link = nil, caption = nil, description = nil, picture = nil, link_label = nil)
    Rails.logger.info "No implementation of messaging for this account type..."
  end

  def recommended_friend_scheme
    return "none"
  end
  
  # default external account has no avatar TODO
  def avatar_url
    return '/assets/icon_no_image.png'
  end
  
  # default profile URL has no profile TODO
  def profile_url
    return  '/assets/icon_no_image.png'
  end

  # Initialize the session -- subclasses provide this.
  #
  def init_session(token)
    raise "Method not implemented!"
  end
  
  # Initialize the session IF POSSIBLE based on service-specific info found in the request cookies.
  #
  # @return boolean
  #
  def init_session_from_cookies(cookies)
    return false
  end
  
end
