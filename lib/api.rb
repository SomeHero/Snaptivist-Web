# this is a publicly available API. As yet there is no authentication.

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
  end

  resource :clients do

    desc "Return all petitions for the specified client."
    get "/:id/petitions", :rabl => "petitions" do
      client = Client.find(params[:id])
      @petitions = Petition.where(:client_id => client.id)
        .order("created_at desc")             
    end

    desc "Create a new petition for the specified client"
    post "/:id/petitions", :rabl => "petition" do

      client = Client.find(params[:id])
      binding.pry
      #TODO: This is kind of a hack
      attributes = JSON.parse(params[:petition])

      attributes["email_configurations_attributes"].each do |config|
        config.delete("email_type")
      end
      ### END HACK ####

      @petition = Petition.new(attributes)

      #@petition.target = Target.first
      @petition.title = @petition.name
      @petition.client = client

      if params[:file_image]
        @petition.header_image = ActionDispatch::Http::UploadedFile.new(params[:file_image])
      end

      if params[:file_premium_image]
        @petition.premium_image = ActionDispatch::Http::UploadedFile.new(params[:file_premium_image])
      end

      @petition.save!

    end

    desc "Updates a petition for the specified client"
    put "/:client_id/petitions/:id", :rabl => "petition" do

      binding.pry
      client = Client.find(params[:client_id])
      @petition = Petition.find(params[:id])
    
      #TODO: This is kind of a hack
      attributes = JSON.parse(params[:petition])
      attributes.delete("share_count")
      attributes.delete("delivery_count")
      attributes.delete("image_full_url")

      attributes["email_configurations_attributes"].each do |config|
        config.delete("email_type")
      end
      ### END HACK ####

      @petition.update_attributes(attributes)

      if params[:file_image]
        @petition.header_image = ActionDispatch::Http::UploadedFile.new(params[:file_image])
      end

      if params[:file_premium_image]
        @petition.premium_image = ActionDispatch::Http::UploadedFile.new(params[:file_premium_image])
      end

      @petition.save!
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
     
    end

  end

  resource :themes do

    desc "Return all themes."
    get "/", :rabl => "themes" do
      @themes = Layout.find(params[:layout_id]).themes
                        
    end

  end

end