require 'koala'

class FacebookAccount < ExternalAccount
  cattr_accessor :api
  
  self.api = nil
  
  # return the permissions we require of Facebook in a string appropriate for use in calls to the FB authentication API
  def self.required_permissions
    return ['email', 'publish_stream', 'user_birthday', 'friends_birthday']
  end
  
  # return minimum permissions that we always need with Facebook
  def self.minimum_permissions
    return ['email', 'user_birthday', 'friends_birthday']
  end
  
  # find a friend by the Facebook external ID
  def find_friend_by_facebook_id(fb_id)
    if fb_id == external_id
      return user
    else
      friend_index = get_friends.index{|i| i['id'].to_i == fb_id.to_i}
      if friend_index
        FacebookAccount.find_or_create(get_friends[friend_index]).user
      else
        return nil
      end
    end
  end
  
  # find the user or create him based on the FB login info
  def self.find_or_create(person, authenticated = false, allowed = false)

    # if the user is not logged into facebook, return no user
    if person['id'].blank?
      return nil
    end
    
    # find the account for the user
    acct = find_by_external_id(person['id'])
    if acct.blank?
      # create a new account and user record for the user
      user = User.create(:name => make_name(person), :email => person['email'])

      attrs = {:user_id => user.id, :external_id => person['id'], :email => person['email']}
      attrs[:authenticated_at] = Time.now if authenticated
      attrs[:allowed_at] = Time.now if allowed
      acct = FacebookAccount.create(attrs)
      user.process_authentication
      return acct
    else
      # if necessary, update the user's name and permissions status
      acct.user.name = make_name(person)
      acct.user.save if acct.user.changed?
      acct.email = person['email'] if person['email'] != acct.email
      acct.authenticated_at = Time.now if authenticated && acct.authenticated_at.nil?
      acct.allowed_at = Time.now if allowed && acct.allowed_at.nil?
      acct.save if acct.changed?

      #acct.user.process_authentication

      # return the account
      return acct
    end
  end
  
  # create a name from facebook parts
  def self.make_name(person)
    if person['first_name'] && person['last_name']
      return "#{person['first_name']} #{person['last_name']}"
    else
      return person['name']
    end
  end
  
  # generate the Facebook avatar image
  def avatar_url
    FacebookAccount.avatar_url(external_id)
  end
  
  def self.avatar_url(fb_id)
    "https://graph.facebook.com/#{fb_id}/picture"
  end
  
  # generate Facebook profile URL
  def profile_url
    "http://www.facebook.com/profile.php?id=#{external_id}"
  end
  
  # service name is Facebook
  def service_name
    'Facebook'
  end
  
  # Get a bunch of user accounts based on a list of facebook id's.  For any ID, if no user account exists, generate one.
  def self.get_by_facebook_id(fb_id, name)
    if fb_id.blank?
      return nil
    end
    
    # find the existing accounts
    acct = FacebookAccount.find_by_external_id(fb_id, :include => 'user')
    unless acct
      u = User.create(:name => name)
      acct = FacebookAccount.create(:user => u, :external_id => fb_id)
    end
    
    return acct
  end

  # send a wall post notifying of a gift to multiple accounts
  def self.send_gift_wall_post(fb_accounts, xaction, message)
    # send the message by Facebook wall post
    fb_accounts.each do |fb_account|
      gift_link = nil
      xaction.gifts.each do |g|
        if g.recipient_id == fb_account.user.id
          fb_account.send_wall_message(message, 
                                        g.receive_link(Gift::FACEBOOK_WALL), 
                                        "A #{g.product.title} for you!", 
                                        g.product.subtitle, 
                                        g.image_url("60x60"))
          break
        end
      end
    end
  end
 
  # send a wall message to the person
  def send_wall_message(message, link = nil, caption = nil, description = nil, picture = nil, link_label = nil)
    link_options = {}
    link_options['link'] = link unless link.blank?
    link_options['caption'] = caption unless caption.blank?
    link_options['description'] = description unless description.blank?
    link_options['name'] = link_label unless link_label.blank?
    
    # don't include picture if it isn't an URL, as might happen when using local storage for an image
    link_options['picture'] = picture unless picture.blank? || !(picture =~ /http/)
    begin
      FacebookAccount.api.put_wall_post(message, link_options, external_id)
      Rails.logger.info "Koala gem making facebook wall post"
    rescue Exception => e
      logger.error "ErrorEvent: For user #{user.name}: Failure to post to Facebook wall: error is #{e} #{e.backtrace}"
      return false
    end
    return true
  end
  
    # send a wall message to the person
  def send_wall_picture(picture_url = nil, message=nil, external_id = nil)
    begin
      FacebookAccount.api.put_picture(picture_url, {:message => message}, external_id)
    rescue Exception => e
      logger.error "ErrorEvent: For user #{user.name}: Failure to post picture to Facebook wall: error is #{e} #{e.backtrace}"
      return false
    end
    return true
  end
  
  # set restrictions on an app
  def self.set_app_restrictions(restrictions)
    token = Koala::Facebook::OAuth.new.get_app_access_token
    api = Koala::Facebook::API.new(token)
    api.set_app_restrictions(Koala::Facebook::OAuth.new.app_id, restrictions)
  end
  
  # get friends of the user
  def get_friends(include_self = false)
    unless @friends
      if FacebookAccount.api
        @friends = FacebookAccount.api.get_connections("me", "friends", :fields => 'name,id,birthday')
        @friends << {'name' => user.name, 'id' => external_id, 'birthday' => nil} if include_self
        @friends.sort! {|a, b| a['name'] <=> b['name']}
      else
        @friends = []
      end
    end
    return @friends
  end
  
  # parse Facebook date format
  def self.parse_date(d)
    if d.blank?
      return nil
    end
    
    if d.split('/').length == 2
      d = d + '/1904'
    end
    
    return Date.strptime(d, '%m/%d/%Y')
  end
end
