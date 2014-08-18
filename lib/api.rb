# this is a publicly available API. As yet there is no authentication.
require 'nation_builder_web_hook.rb'
require 'jobs/nationbuilder.rb'
require 'securerandom'

class API < Grape::API
  version 'v1', using: :header, vendor: "Snaptivist"
  format :json
  formatter :json, Grape::Formatter::Rabl

  helpers do
    def current_account
      elements = request.env["HTTP_HOST"].split(":").first.split(".")
      if elements.count == 3
        Account.where(:subdomain => /#{elements.first}/i).first
      else
        error!('404 Not Found', 404)
      end
    end

    def current_user

      binding.pry

      method = params[:action_method]
      
      if method == 'email'

        user = User.find_by_email(params[:email_address])

        if user
          user.first_name = params[:first_name]
          user.last_name = params[:last_name]
          user.zip_code = params[:zip_code]
          
          # if user.action_tags && @petition.action_tags
          #   action_tags = Array.wrap(@petition.action_tags.split(",").collect{|x| x.strip})
          #   current_tags = Array.wrap(user.action_tags.split(",")).collect{|x| x.strip}
        
          #   action_tags.each do |action_tag|
          #     user.action_tags += "," + action_tag if !current_tags.include?(action_tag)
          #   end
          # else
          #   user.action_tags = @petition.action_tags
          # end
          user.save!

        else
         user = User.new do |u|
          u.first_name = params[:first_name]
          u.last_name = params[:last_name]
          u.email = params[:email_address]
          u.password = "password"
          u.password_confirmation = "password"
          u.zip_code = params[:zip_code]
          #u.action_tags = @petition.action_tags
          end

          user.save!

        end

      end

      if method == 'facebook'

        binding.pry 

        auth = params[:auth]

        #raise error if no auth
        Rails.logger.debug "The access token is " + auth["accessToken"]

        #see if we have this FB user in the authentications table
        authentication = Authentication.find_by_provider_and_uid('facebook', auth["userID"])

        @graph =Koala::Facebook::API.new(auth["accessToken"])
        facebook_profile = @graph.get_object("me")

        raise "Unable to retrieve Facebook profile" unless facebook_profile

        if authentication
          #flash[:notice] = "Logged in Successfully"
          user = User.find(authentication.user_id)
          user.first_name = facebook_profile['first_name']
          user.last_name = facebook_profile['last_name']
          user.avatar_url = "http://graph.facebook.com/" + auth["userID"] + "/picture"

          # if user.action_tags  && @petition.action_tags
          #     action_tags = Array.wrap(@petition.action_tags.split(",").collect{|x| x.strip})
          #     current_tags = Array.wrap(user.action_tags.split(",")).collect{|x| x.strip}
          #     action_tags.each do |action_tag|
          #       user.action_tags += "," + action_tag if !current_tags.include?(action_tag)
          #     end
          # else
          #   user.action_tags = @petition.action_tags
          # end
          user.save!

        else

          raise "Unable to process your signature.  Email Address not specified." unless facebook_profile["email"]

          binding.pry
          #so we haven't seen the facebook account before, but let's check the email address because we require them to be unique
          user = User.find_by_email(facebook_profile["email"])

          if !user
            user = User.new
            user.email =  facebook_profile["email"]
            user.first_name = facebook_profile['first_name']
            user.last_name = facebook_profile['last_name']
            user.avatar_url = "http://graph.facebook.com/" + auth["userID"] + "/picture"
            user.password = "James123"
            #user.action_tags = @petition.action_tags
          else
            #TODO
            #we need to append the action tags
            #user.action_tags = @petition.action_tags
          
          end
          #associate the facebook auth with this user
          user.authentications.build(
              :provider => 'facebook', 
              :uid => auth["userID"], 
              :token => auth["accessToken"], 
              :token_secret => auth["token_secret"])

          user.save!

        end

      end

      return user
    
    end

  end

  resource :images do
    desc "Upload image"
    post "/", :rabl => "image" do
      
      @image = Image.new
      @image.photo = ActionDispatch::Http::UploadedFile.new(params[:file])

      @image.save!
    end

  end

  resource :clients do

    desc "Returns all clients"
    get "/", :rabl => "clients" do
      @client = Client.all
    end

    desc "Return all campaigns for the specified client."
    get "/:id/campaigns", :rabl => "campaigns" do
      client = Client.find(params[:id])
      @campaigns = Campaign.includes("campaign_pages")
        .where(:client_id => client.id)
        .order("created_at desc")             
    end

    desc "Return all campaigns for the specified client."
    get "/:client_id/campaigns/:id", :rabl => "campaign" do
      client = Client.find(params[:client_id])
      @campaign = Campaign.includes("campaign_pages")
        .includes("email_configurations")
        .find(params[:id])           
    end

    desc "Create a new campaign for the specified client"
    post "/:id/campaigns", :rabl => "campaign" do

      client = Client.find(params[:id])

      @campaign = Campaign.create!({
          title: params[:title],
          subdomain: params[:subdomain],
          client: client
      })

    end

    desc "Updates a campaign for the specified client"
    put "/:id/campaigns/:campaign_id", :rabl => "campaign" do

      client = Client.find(params[:id])
      @campaign = Campaign.find(params[:campaign_id])

      layout = Layout.find(params[:layout_id])
      theme = layout.themes.find(params[:theme_id])

      @campaign.layout = layout
      @campaign.theme = theme

      pages = params[:campaign_pages]

      all_pages = @campaign.campaign_pages.collect { |page| page.id }
    
      pages.each do |page|

        campaign_page = nil

        if(page.id)

          all_pages.delete(page.id)
          campaign_page = @campaign.campaign_pages.find(page.id)

        else

          campaign_page = @campaign.campaign_pages.new({
            page_id: page.page_id,
            position: page.position,
          })

       end

       binding.pry
        if(page.action) 
          if(page.action.type === "poll_action") 
            action = campaign_page.create_or_update_poll(page.action)
          elsif(page.action.type === "poll_results") 
            action = campaign_page.create_or_update_poll_results(page.action)
          elsif (page.action.type === "signature_action")
            action = campaign_page.create_or_update_petition(page.action)
          elsif (page.action.type == "tweet_action")
            action = campaign_page.create_or_update_tweet(page.action)
          elsif (page.action.type == "premium_action")
            action = campaign_page.create_or_update_premium(page.action)
          elsif (page.action.type == "donation_action")
            action = campaign_page.create_or_update_donation(page.action)
          end
        end

        campaign_page.content = page.content.to_json
        campaign_page.save!

      end

      all_pages.each do |page_id|
        @campaign.campaign_pages.find(page_id).delete
      end

      @campaign.save!

    end

    desc "Deletes a campaign for the specified client"
    delete "/:id/campaigns/:campaign_id" do

      client = Client.find(params[:id])
      campaign = client.campaigns.find(params[:campaign_id])

      campaign.destroy
    end


    desc "Return all petitions for the specified client."
    get "/:id/petitions", :rabl => "petitions" do
      client = Client.find(params[:id])
      @petitions = Petition.where(:client_id => client.id)
        .order("created_at desc")             
    end

    desc "Create a new petition for the specified client"
    post "/:id/petitions", :rabl => "petition" do

      client = Client.find(params[:id])
      layout = Layout.first
      theme = layout.themes.first

      @petition = Petition.create({
          title: params[:title],
          subdomain: params[:subdomain],
          layout: layout,
          theme: theme
        })

      #REDIS.set("action-" + @petition.id, params[:content])

    end

    desc "Updates a petition for the specified client"
    put "/:client_id/petitions/:id", :rabl => "petition" do

      client = Client.find(params[:client_id])
      @petition = Petition.find(params[:id])
    
      #TODO: This is kind of a hack


      REDIS.set("action-" + @petition.id.to_s, params[:content])

    end

	desc "Saves Nation Builder OAuth Credentials for the specified client"
    post "/:client_id/nation_builder_oauth_credentials" do

      session = env['rack.session']

      client = Client.find(params[:client_id])

      session['nation_name'] = params[:nation_name]
      session['client_app_id'] = params[:client_uid]
      session['client_secret'] = params[:client_secret]
      session['redirect_uri'] = params[:redirect_uri]

    end

    # desc "crm webhook to add or update a user"
    # post "/:client_id/webhooks/user" do
    #   Resque.enqueue(Nationbuilder, params[:client_id], params[:payload])
    # end

    desc "crm webhook to add or update a donation"
    post "/:client_id/webhooks/donation" do
      client = Client.find(params[:client_id], client)
      
      webhook = CrmWebHook::NationBuilderCrmWebHook.new
      webhook.create_or_update_donation(params[:payload])

    end


    desc "get supporters for a client"
    get "/:client_id/supporters", :rabl => "supporters" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      client = Client.find(params[:client_id])
      order_column = "last_name"
      @supporters = client.supporters.order(order_column).limit(page_size).offset(offset)
      @total = client.supporters.count
    end


  end

  resource :layouts do

    desc "Return all layouts."
    get "/", :rabl => "layouts" do
      @layouts = Layout.all
                        
    end

  end

  resource :email_types do

    desc "Return all email types."
    get "/", :rabl => "email_types" do
      @email_types = EmailType.order("position asc")
        .all
                        
    end

  end    

  resource :conditional_action_tag_types do

    desc "Return all conditional action tag types."
    get "/", :rabl => "conditional_action_tag_types" do
      @conditional_action_tag_types = ConditionalActionTagType.all
                        
    end

  end 

  resource :campaigns do
    
    segment '/:campaign_id' do

      resource :actions do

        desc "Saves an action that a users takes to the database"
        post "/:id" do

          campaign = Campaign.find(params[:campaign_id])
          rails "Unable to find campaign" unless campaign

          action = Action.find(params["action_id"])
          rails "Unable to find action" unless action

          user = current_user
          rails "Unable to find or create a user" unless user

          type = params["type"]

          if type == 'poll_action'
            poll_choice =PollChoice.find(params["choice_id"])

            UserCampaignVoteAction.create!(
              action: action,
              poll_choice: poll_choice,
              user: user
            )
          end
          if type == 'signature_action'

            UserCampaignSignatureAction.create!(
              action:action,
              reason: params["comment"],
              user:user
            )
          end

        end

        desc "Returns all action responses for a given action"
        get "/:id/responses", :rabl => "user_campaign_actions" do
          campaign = Campaign.find(params[:campaign_id])
          rails "Unable to find campaign" unless campaign

          action = Action.find(params[:id])
          rails "Unable to find action" unless action

          page_size = 10
          offset = 0

          if params[:offset]
            offset = params[:offset]
          end

          @user_campaign_actions = action.user_campaign_actions.order("created_at DESC").limit(page_size).offset(offset)
          @total = action.user_campaign_actions.count
        end
      end
        
    
    end
  end   

  resource :pages do

    desc "Return all pages for a give layout."
    get "/", :rabl => "pages" do
      layout = Layout.find(params[:layout_id])
      @pages = layout.pages.order("position asc")           
    end

  end    

  resource :petitions do

    desc "Return all petitions."
    get "/", :rabl => "petitions" do
      @petitions = Petition.all
                        
    end

    desc "Return the specified petition."
    get "/:id", :rabl => "petition" do
      @petition = Petition.find(params[:id])   
      @content =  JSON.parse(REDIS.get("action-" + @petition.id.to_s))
     
    end

    desc "get signatures for a petition"
    get "/:id/signatures", :rabl => "signatures" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @signatures = @petition.signatures.limit(page_size).offset(offset)
      @total = @petition.signatures.count
    end

    desc "get shares for a petition"
    get "/:id/shares", :rabl => "shares" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @shares = @petition.signatures.where(:shared => true).limit(page_size).offset(offset)
      @total = @petition.signatures.where(:shared => true).count
    end

    desc "get tweet for a petition"
    get "/:id/tweets", :rabl => "tweets" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @signatures = @petition.signatures.where(:delivered => true).limit(page_size).offset(offset)
      @total = @petition.signatures.where(:delivered => true).count
    end

    desc "get premium redemptions for a petition"
    get "/:id/premiums", :rabl => "premiums" do

      page_size = 10
      offset = 0

      if params[:offset]
        offset = params[:offset]
      end

      @petition = Petition.find(params[:id])   
     
      @premiums = @petition.premium_redemptions.limit(page_size).offset(offset)
      @total = @petition.premium_redemptions.count
    end

  end

  resource :themes do

    desc "Return all themes."
    get "/", :rabl => "themes" do
      @themes = Theme.all
                        
    end

  end


end