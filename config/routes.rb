Tzm::Application.routes.draw do
  devise_for :users
  resources :users, :path => 'user'
  resources :coordinators, :only => [:new, :create]
  resources :feedback_requests, :path => 'feedback', :only => [:index,:show,:new,:create]

  resources :chapters

  resources :geographic_locations, :as => 'geo', :path => 'geo', :only => [:index,:show] do
    member do
      get :territory_options
    end
  end

  resources :site_options, :only => [:index,:edit,:update]
  
  pages = ['protocols']

  pages.each do |page|
    get page, :to => 'pages#show', :uri => page
    get page+'/edit', :to => 'pages#edit', :uri => page, :as => "edit_#{page}"
    put page, :to => 'pages#update', :uri => page
  end

  root :to => "chapters#index"
end
