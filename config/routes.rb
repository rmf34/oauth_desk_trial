OauthDeskTrial::Application.routes.draw do
  devise_for :users

  get '/auth/:provider/callback', to: 'authentications#create'
  resources :authentications
  get '/auth/:provider/callback', :to => 'authentications#create'
  resources :authentications, :only => [:new, :destroy] do
    member do
      get :desk_show
    end
  end

  get 'about', to: 'static_pages#about'
  root 'authentications#new'
end
