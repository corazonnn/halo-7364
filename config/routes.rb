Rails.application.routes.draw do
  
  root to: 'products#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  
  get 'signup' ,to: 'users#new'
  
  get 'chat-room' ,to: 'rooms#show'
  
  resources :users, only: [:index, :show, :create,:edit,:update] 
   
  resources :products
  
  
  #ユーザが「頑張ったね！」できるようにルーティングしていく
  resources :goods, only:[:create,:destroy]
  
  resources :comments, only:[:create,:destroy]
  
  resources :messages, only: [:create, :destroy]
end
