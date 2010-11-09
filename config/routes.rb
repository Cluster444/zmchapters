Tzm::Application.routes.draw do
  devise_for :users
  resources :chapters
  resources :users, :path => 'user'

  resources :geographic_locations, :as => 'geo', :path => 'geo', :only => [:index,:show] do
    member do
      get :territory_options
    end
  end

  root :to => "chapters#index"
end
