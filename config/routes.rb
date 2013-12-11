SnaptivistWeb::Application.routes.draw do

  devise_for :clients

  mount API => "/api", :at => '/'

  namespace :api do
    match 'petitions/more', :to => 'petitions#more'
  
    resources :petitions do 
      member do
        post 'share'
        post 'sign'
        post 'sign_another'
        post 'sign_with_facebook'
        post 'share_with_facebook'
        get 'signatures'
        get 'tweets'
      end
    end
    resources :phonecampaigns do
      member do
        post 'share'
        post 'log'
        post 'log_with_facebook'
        get 'call_results'
      end
    end
    resources :polls
    resources :targets
  end
  
  namespace :dashboard do
    resources :clients
    resources :widgets
    resources :client_views, only: [:show]
  end


  match 'client_views/:layout/:template', :to => 'client_views#show'
  match '/' => 'home#index', :constraints => { :subdomain => 'dev' }
  match '/welcome' => 'home#welcome'
  
  match '/deliver/:signature_id' => 'actions#view', :constraints => { :subdomain => /.+/ }
  match '/' => 'actions#view', :constraints => { :subdomain => /.+/ }
  match 'petitions/:action_title', :to =>'petitions#view'
  match 'polls/:action_title', :to =>'polls#view'
  match 'phonecampaigns/:action_title', :to => 'phonecampaigns#view'
  
  match 'oauth/nb' => 'oauth#nation_builder'
  match "auth/check/:provider" => 'authentications#check' 

  resources :authentications
  resources :targets
  resources :twitter

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get 'dashboard/clients/sign_up' => 'dashboard/clients/registrations#new_client', :as => 'new_client_registration'
  get "home/index"

  get "home/welcome"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # The following line is created by Devise automatically
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"},
  controllers: {omniauth_callbacks: "authentications", registrations: "registrations"}

  resources :users


  resource :auth do
    collection do
      post :login
      get :logout
    end
  end
  resources :clients do
    member do
      get :login
      get :crm_setup
      post :validate
      get :logout
    end
    collection do
      post :confirm
      get :demo
      get :customers
      get :twitter_support
    end
    member do
      get :customers
    end
  end


  
  # Let's add the root route
  root :to => "home#index"


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
