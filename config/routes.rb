Lgp::Application.routes.draw do

  # auth
  resources :authentications, :only=>[:create]
  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/:provider' => 'authentications#show'


  # public
  resources :welcome, :only=>[:index]
  resources :invite_codes, :only=>[:create]
  resources :invite_requests, :only=>[:create]
  
  resources :conversations, :messages
  match "inbox" => "conversations#index"
  match "sentbox" => "conversations#sent"
 

  # user scoped
  devise_for :users
  namespace :users do
    resources :dashboards, :only => [ :index, :update ]
    # change message to be resource based route --- not match when implemented.
    #match "/messages" => "messages#message", :as=>"message"
    resources :movies, :only => [ :index, :show ]
    resources :photos, :only => [ :index, :create , :update, :destroy ]
    resources :profiles, :only => [ :index, :show, :edit ]
    resources :watch_lists, :only => [ :create, :destroy ]
  end

  # admin scoped
  resources :admin, :only=>[:index]
  namespace :admin do
    resources :invite_codes
    resources :movies
    resources :questions
    resources :schedules
    resources :theaters
    resources :zip_locs
  end

  # default route
  root :to => 'welcome#index'
 
  match ':controller(/:action(/:id))'

end
