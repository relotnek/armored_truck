ArmoredTruck::Application.routes.draw do
  devise_for :users
  root "main#index"

  get "main/index"
  resources :safes
  resources :users
  resources :keys

  post 'safe/upload' => 'safes#upload'
  post 'safe/decrypt' => 'safes#decrypt'
  get 'user/generate' => 'users#generate'
  post 'key/generate' => 'keys#generate'
end
