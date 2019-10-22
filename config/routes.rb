Rails.application.routes.draw do


  get 'login' => "session#login_form"
  post 'login' => "session#login"
  post 'logout' => "session#logout"

  root "home#top"
  get 'signup' => "users#new"
  post 'signup' => "users#create"

end