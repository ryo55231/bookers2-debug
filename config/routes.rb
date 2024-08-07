Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
      resources :book_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
  resources :groups do      #ここ！
    get "join" => "groups#join"
  resources :group_users, only: [:create, :destroy]
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
   end
  resources :users, only: [:index,:show,:edit,:update] do
      resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
 end
  resources :chats, only: [:show, :create]
 get '/search', to: 'searches#search'
 #6/8ゲストユーザーログインのルート記述
    devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  #6/8
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
