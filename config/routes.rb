Tzm::Application.routes.draw do
  resources :members
  get '/chapters/country/:id', :to => 'chapters#index_country', :constraints => {:id => /[1-9][0-9]*/}
  get '/chapters/country/:name', :to => 'chapters#index_country', :as => 'country_chapters'
  resources :chapters

  root :to => 'chapters#index'
end
