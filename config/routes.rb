OauthDeskTrial::Application.routes.draw do
  devise_for :users

  get '/auth/:provider/callback', to: 'authentications#create'
  resources :authentications

  get 'about', to: 'static_pages#about'
  root 'authentications#new'
end
