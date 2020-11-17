Rails.application.routes.draw do
  #本当はroot to:'products#index'まず最初にプロダクトの一覧を表示する。だけど一旦productsを作るまでは以下のようにする
  root to: 'users#index'
  
  get 'signup' ,to: 'users#new'
  resources :users, only: [:index, :show, :create,:edit,:update]

end
