ArmoredTruck::Application.routes.draw do
  devise_for :users
  root "main#index"
  
  get "main/index"
  resources :safes
  resources :users

  post 'safe/upload' => 'safes#upload'
end
