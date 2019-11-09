# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#top"
  get "signup" => "users#new"
  post "signup" => "users#create"

  get "login" => "session#login_form"
  post "login" => "session#login"
  post "logout" => "session#logout"

  get "users/:id" => "users#show", as: "user_page"

  get "users/:id/profile" => "users#edit_profile", as: "profile"
  patch "users/:id/profile" => "users#update_profile", as: nil
  get "users/:id/password" => "users#edit_password", as: "password"
  patch "users/:id/password" => "users#update_password", as: nil

  post "users/:id/posts" => "posts#create", as: "posts"
end
