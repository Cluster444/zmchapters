Tzm::Application.routes.draw do
  devise_for :users
  resources :users, :path => 'u' do
    member do
      put 'join_chapter/:chapter_id', :action => :join_chapter, :as => 'join_chapter'
    end
  end

  resources :coordinators, :only => [:new, :create, :destroy]
  resources :feedbacks, :path => 'feedback', :except => [:destroy]
  
  resources :chapters, :except => [:destroy] do
    collection do
      get :select_country_for_new
      get :select_territory_for_new
    end
    member do
      put "links/:link_id", :action => :update_link, :as => :link_for
      post :links, :action => :create_link, :as => :new_link_for
    end
  end
  
  resources :links
  resources :tasks
  resources :events
  resources :locations, :only => [:index, :show, :new, :create]

  resources :site_options, :only => [:index,:edit,:update]
  
  pages = ['protocols',"home"]

  pages.each do |page|
    get page, :to => 'pages#show', :uri => page
    get page+'/edit', :to => 'pages#edit', :uri => page, :as => "edit_#{page}"
    put page, :to => 'pages#update', :uri => page
  end
  
  root :to => "pages#show", :uri => "home"

  get "/:chapter_name", :controller => :chapters, :action => :show, :as => 'chapter'
  get "/:chapter_name/edit", :controller => :chapters, :action => :edit, :as => 'edit_chapter'
  put "/:chapter_name", :controller => :chapters, :action => :update, :as => 'chapter'
end
