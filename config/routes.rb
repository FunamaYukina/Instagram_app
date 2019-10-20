Rails.application.routes.draw do


  get 'posts/index'
  post "posts/create" => "posts#create"

  get 'login' => "users#login_form"
  post 'login' => "users#login"
  post "users/logout" => "users#logout"

  get '/' => "home#top"
  get "signup" => "users#new"
  post 'users/create' => "users#create"

end
