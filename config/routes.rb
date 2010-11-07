Tzm::Application.routes.draw do
  resources :chapters
  resources :users

  root :to => "chapters#index"
end
