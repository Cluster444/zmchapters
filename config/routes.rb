Tzm::Application.routes.draw do
  resources :members
  resources :chapters

  root :to => 'chapters#index'
end
