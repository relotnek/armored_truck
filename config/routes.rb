ArmoredTruck::Application.routes.draw do
  root "main#index"
  
  get "main/index"
  resources :safes
  resources :users
end
