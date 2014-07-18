Exoplanets::Application.routes.draw do
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "registrations"}

  namespace :admin do
    root :to => "home#index"

    resources :users
    resources :planets

    resources :styles, only: :index
  end
end
