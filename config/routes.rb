OauthDeskTrial::Application.routes.draw do
  devise_for :users

  get '/auth/:provider/callback', :to => 'authentications#create'
  patch '/authentications/:authentication_id/case/:id', :to => 'authentications#desk_update', :as => 'desk_update'

  resources :authentications, :only => [:new, :destroy] do
    member do
      get :desk_show
    end
  end

  get 'about', to: 'static_pages#about'
  root 'authentications#new'
end
