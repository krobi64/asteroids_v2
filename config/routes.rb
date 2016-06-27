Mpc::Application.routes.draw do

  devise_for :users

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :sources, only: [:index] do
    member do
      get :latest
    end
  end

  resources :editions, only: [:index, :new, :create, :edit, :update, :show] do
    collection do
      get :current
    end

    member do
      put :share
      put :publish
    end
  end

  #z++
  root :to => 'mpc#index'
  get 'mpc' => 'mpc#index'
  get 'db_search' => 'db_search#index'
  get 'light_curve' => 'light_curve#index'
  get 'summary' => 'mpc#summary'
  get 'neocp_obs' => 'neocp_obs#index'
  get 'neos' => 'neos#index'
  get 'obs_request' => 'obs_request#index'
  get 'submit_obs' => 'submit_obs#index'
  get 'header' => 'mpc#header'
  get 'dependencies' => 'mpc#dependencies'
  get 'footer' => 'mpc#footer'
  get 'wrapper' => 'mpc#wrapper'
  get 'ws' => 'ws#index'
  #get 'wp_post' => 'wp_post#index'

  get 'iau/MPCORB/CometEls.txt'              => 'downloads#CometEls'
  get 'iau/Ephemerides/Comets/Soft00Cmt.txt' => 'downloads#Soft00Cmt'
  get 'iau/Ephemerides/Comets/Soft01Cmt.txt' => 'downloads#Soft01Cmt'
  get 'iau/Ephemerides/Comets/Soft02Cmt.txt' => 'downloads#Soft02Cmt'
  get 'iau/Ephemerides/Comets/Soft03Cmt.txt' => 'downloads#Soft03Cmt'
  get 'iau/Ephemerides/Comets/Soft04Cmt.txt' => 'downloads#Soft04Cmt'
  get 'iau/Ephemerides/Comets/Soft05Cmt.txt' => 'downloads#Soft05Cmt'
  get 'iau/Ephemerides/Comets/Soft06Cmt.txt' => 'downloads#Soft06Cmt'
  get 'iau/Ephemerides/Comets/Soft07Cmt.txt' => 'downloads#Soft07Cmt'
  get 'iau/Ephemerides/Comets/Soft08Cmt.txt' => 'downloads#Soft08Cmt'
  get 'iau/Ephemerides/Comets/Soft09Cmt.txt' => 'downloads#Soft09Cmt'
  get 'iau/Ephemerides/Comets/Soft10Cmt.txt' => 'downloads#Soft10Cmt'
  get 'iau/Ephemerides/Comets/Soft11Cmt.txt' => 'downloads#Soft11Cmt'
  get 'iau/Ephemerides/Comets/Soft12Cmt.txt' => 'downloads#Soft12Cmt'
  get 'iau/Ephemerides/Comets/Soft13Cmt.txt' => 'downloads#Soft13Cmt'
  get 'iau/Ephemerides/Comets/Soft14Cmt.txt' => 'downloads#Soft14Cmt'
  get 'iau/Ephemerides/Comets/Soft15Cmt.txt' => 'downloads#Soft15Cmt'
  get 'iau/Ephemerides/Comets/Soft16Cmt.txt' => 'downloads#Soft16Cmt'

  # Old way of doing it below:
  # map.connect 'search', :controller => 'db_search', :action => 'index'
  # map.root :controller => 'mpc', :action => 'index'
  # map.connect 'iau/*path', :controller => 'pages', :action => 'show'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
  # match ':action' => 'static#:action'
  # match ':page_name' => 'static#show'
  match '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get

  namespace :ws do
    resources :defaults => { :format => 'xml' }
  end
end
