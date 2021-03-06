FileSupportMovingstories::Application.routes.draw do
  root 'projects#index'
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_error'
  get '/422' => 'errors#unprocessable_entity'  
  apipie
  get "password_resets/new"
  get "pages/about"
  get "pages/contact"
  get "pages/howto"  
  # get '/data_tracks/provide', to: 'data_tracks#provide'
  # post '/data_tracks/import', to: 'data_tracks#import'
  get "myprojects" => "projects#mine", :as => "myprojects"
  get "movement_annotations/for"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "tracks_ajax" => "data_tracks#index_data_tables", :as => "tracks_ajax"
  #export routes need to be above the resources 
  get "projects/export"
  get "movement_groups/export"
  get "takes/export"
  resources :sensor_types
  resources :movers
  resources :access_groups
  resources :movement_annotations
  resources :data_tracks
  resources :movement_groups
  resources :projects do
    post 'make_public', on: :member
  end
  resources :takes  
  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, except: [:index]  
  match 'tagged' => 'movement_groups#tagged', :via => [:get], :as => 'tagged'
 
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
end
