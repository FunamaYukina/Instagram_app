Rails.application.routes.draw do


  get 'login' => "users#login"

  get '/' => "home#top"
  get "signup" => "users#new"

end
