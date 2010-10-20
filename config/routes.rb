Tzm::Application.routes.draw do
  resources :members
  get '/chapters/:type/:value', :to => 'chapters#index_group'
  resources :chapters

  root :to => 'chapters#index'
end
