Tzm::Application.routes.draw do
  devise_for :users

  resources :chapters do
    resources :coordinators, :only => [:index, :new, :create, :destroy]
    collection do
      get :search
    end
  end

  resources :users, :path => 'user'
    
  resources :geographic_locations, :as => 'geo', :path => 'geo', :only => [:index,:show] do
    member do
      get :territory_options
    end
  end
  
  pages = ['protocols']

  pages.each do |page|
    get page, :to => 'pages#show', :uri => page
    get page+'/edit', :to => 'pages#edit', :uri => page, :as => "edit_#{page}"
    put page, :to => 'pages#update', :uri => page
  end

  root :to => "chapters#index"
end
