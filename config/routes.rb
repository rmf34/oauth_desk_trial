OauthDeskTrial::Application.routes.draw do
  devise_for :users

  get 'about', to: 'static_pages#about'

  root 'authorizations#index'
end
