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
  #管理者用のルーティング
  namespace :admin do
    resources :products, only: [:index, :new, :create, :show,  :edit, :destroy]
  end
  
  # ユーザ(user)がプロダクト(product)に対していいね(good)をする
  resources :goods, only: %i[create destroy]
  #ユーザ(user)がプロダクト(product)に対してコメント(comment)をする
  resources :comments, only: %i[create destroy]
  #ユーザ(user)がチャットグループに対して発言(message)をする
  resources :messages, only: %i[create destroy]
end
