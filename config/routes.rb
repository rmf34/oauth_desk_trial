OauthDeskTrial::Application.routes.draw do

  devise_for :users
  # root 'welcome#index'
  get 'about', to: 'static_pages#about'
end
