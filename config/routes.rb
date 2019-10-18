Rails.application.routes.draw do


  get 'login' => "users#login"
  post 'users/login' => "users#login"

  get '/' => "home#top"
  get "signup" => "users#new"
  post 'users/create'=>"users#create"

end
