Rails.application.routes.draw do


  get 'login' => "session#login_form"
  post 'login' => "session#login"
  post 'logout' => "session#logout"

  get 'posts/index'
  post "post" => "posts#create"

  get 'login' => "users#login_form"
  post 'login' => "users#login"
  post "users/logout" => "users#logout"

  root "home#top"
  get 'signup' => "users#new"
  post 'signup' => "users#create"

end
