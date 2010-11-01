Tzm::Application.routes.draw do
  devise_for :users
  
  #get '/chapters/country/:id', :to => 'chapters#index_country', :constraints => {:id => /[1-9][0-9]*/}
  #get '/chapters/country/:name', :to => 'chapters#index_country', :as => 'country_chapters'

  resources :chapters do
    resources :external_urls, :except => [:show]
  end
  
  get '/geo/1', :to => redirect("/geo")
  resources :geographic_locations, :as => 'geo', :path => 'geo', :only => [:index,:show] 

  resources :users, :path => 'user'

  get '/javascripts/dynamic_chapters.(:format)', :to => 'javascripts#dynamic_chapters'

  root :to => 'chapters#index'
end
