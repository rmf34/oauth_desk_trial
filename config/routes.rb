OauthDeskTrial::Application.routes.draw do
  devise_for :users

  get '/auth/:provider/callback', :to => 'authentications#create'
  patch '/authentications/:authentication_id/resource/:id', :to => 'authentications#desk_update', :as => 'desk_update'
  post  '/authentications/:id/resource', :to => 'authentications#desk_create', :as => 'desk_create'

  resources :authentications, :only => [:new, :destroy] do
    member do
      get :desk_show
    end
  end

  get 'about', :to => 'static_pages#about'
  root 'authentications#new'
end
