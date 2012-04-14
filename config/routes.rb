Lgp::Application.routes.draw do

  resources :zip_locs

  resources :schedules

  resources :theaters

  resources :movies, :only => [:index, :show]

  resources :questions

  devise_for :users, :controllers => { :registrations => "users" }
  devise_scope :user do
    match "/registration/step2" => "users#step2"
    #match "/users/" => "users#index"
    #match "/users" => "users#index"
    #match "/users/index" => "users#index"
    #match "/users/:id" => "users#show"
    #match "/users/:id/edit" => "users#edit"

    resources :users, :only => [ :index, :show, :edit ] do
      resources :users_pic_test, :only =>[ :new, :create ]
    end

  end

  resources :admin, :only=>[:index]
  namespace :admin do
    resources :movies
    resources :invite_codes
  end

  # resources :users
  
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
  root :to => 'welcome#index'
  resources :invite_codes
  match "/dashboard" => "dashboard#dashboard", :as=>"dashboard"
  match "/profile" => "profile#profile", :as=>"profile"
  match "/message" => "message#message", :as=>"message"

  # TODO:  why did you use specific function here and not index ??
  #  mcp - I changed to using REST paths.  ( you can remove these comments )
  #match "/watchlist" => "watchlist#watchlist", :as=>"watchlist"
  resources :watchlist, :only=>[ :index, :create, :destroy ]

  match "/welcome/verify_code" => "welcome#verify_code"
  match "/signup" => "welcome#signup"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
