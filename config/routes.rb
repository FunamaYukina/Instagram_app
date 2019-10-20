Rails.application.routes.draw do


  get 'login' => "users#login_form"
  post 'login' => "users#login"
  post 'logout' => "users#logout"

  get '/' => "home#top", as: "home"
  get 'signup' => "users#new"
  post 'signup' => "users#create"

end