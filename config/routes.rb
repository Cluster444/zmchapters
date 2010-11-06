Tzm::Application.routes.draw do
  resources :chapters

  root :to => "chapters#index"
end
