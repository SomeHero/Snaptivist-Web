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

  resource :layouts do

    desc "Return all layouts."
    get "/", :rabl => "layouts" do
      @layouts = Layout.all
                        
    end

  end

  resource :petitions do

    desc "Return all petitions."
    get "/", :rabl => "petitions" do
      @layouts = Layout.all
                        
    end

  end

  resource :themes do

    desc "Return all themes."
    get "/", :rabl => "themes" do
      @layouts = Layout.all
                        
    end

  end

end