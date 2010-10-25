Tzm::Application.routes.draw do
  devise_for :members
  
  get '/chapters/country/:id', :to => 'chapters#index_country', :constraints => {:id => /[1-9][0-9]*/}
  get '/chapters/country/:name', :to => 'chapters#index_country', :as => 'country_chapters'

  resources :chapters
  resources :members, :except => [:index], :path => 'member'
  resources :external_urls

  get '/external_urls/chapter/:chapter_id/edit', :to => 'external_urls#edit', :as => 'edit_chapter_external_urls'
  
  get '/javascripts/dynamic_chapters.js', :to => 'javascripts#dynamic_chapters'

  root :to => 'chapters#index'
end
