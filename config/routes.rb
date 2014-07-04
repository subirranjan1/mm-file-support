FileSupportMovingstories::Application.routes.draw do
  root 'projects#index'
  get "pages/about"
  get "pages/contact"
  resources :sensor_types
  resources :movers
  resources :movement_annotations
  resources :data_tracks
  resources :movement_groups
  resources :projects
  get "myprojects" => "projects#mine", :as => "myprojects"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
#  root :to => "users#new"
  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  match 'tagged' => 'movement_groups#tagged', :via => [:get], :as => 'tagged'
 
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_error'
  get '/422' => 'errors#unprocessable_entity'

end
