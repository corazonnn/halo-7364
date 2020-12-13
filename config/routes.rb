Rails.application.routes.draw do
  root to: 'products#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'

  get 'chat-room', to: 'rooms#show'

  get 'search', to: 'products#index'

  resources :users, only: %i[index show create edit update]

  resources :products

  # ユーザが「頑張ったね！」できるようにルーティングしていく
  resources :goods, only: %i[create destroy]

  resources :comments, only: %i[create destroy]

  resources :messages, only: %i[create destroy]
end
