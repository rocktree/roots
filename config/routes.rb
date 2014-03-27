Roots::Application.routes.draw do

  # ------------------------------------------ Admin

  get '/admin' => 'admin#dashboard', :as => :admin_dashboard
  namespace :admin do
    resources :users, :except => [:show]
  end

  # ------------------------------------------ Devise

  devise_for :users, skip: [:sessions, :registrations]
  devise_scope :user do
    get '/login' => 'devise/sessions#new', :as => :new_user_session
    post '/login' => 'devise/sessions#create', :as => :user_session
    get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # ------------------------------------------ Root

  root :to => 'application#index'

end
