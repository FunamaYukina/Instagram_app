# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#top"
  get "signup" => "users#new"
  post "signup" => "users#create"

  get "login" => "session#login_form"
  post "login" => "session#login"
  post "logout" => "session#logout"

  get "users/:username" => "users#show", as: "user"

  get "settings/profile" => "profiles#edit", as: "profile"
  patch "settings/profile" => "profiles#update", as: nil
  get "settings/password" => "passwords#edit", as: "password"
  patch "settings/password" => "passwords#update", as: nil

  post "users/:id/posts" => "posts#create", as: "posts"
end
