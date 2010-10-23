Tzm::Application.routes.draw do
  devise_for :members
  
  get '/chapters/country/:id', :to => 'chapters#index_country', :constraints => {:id => /[1-9][0-9]*/}
  get '/chapters/country/:name', :to => 'chapters#index_country', :as => 'country_chapters'

  resources :chapters
  resources :members, :only => [:show]
  
  get '/javascripts/dynamic_chapters.js', :to => 'javascripts#dynamic_chapters'

  root :to => 'chapters#index'
end
