# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#top"
  get "signup" => "users#new"
  post "signup" => "users#create"

  get "login" => "session#login_form"
  post "login" => "session#login"
  post "logout" => "session#logout"

  get "users/:id" => "users#show", as: "user_page"
  get "users/:id/edit" => "users#edit", as: "user_profile"
  post "users/:id/update" => "users#update", as: "user_update"

  post "post" => "posts#create"
  # post "users/:user_id/posts/create" => "posts#create", as: "post"

  get "images/index"
end
