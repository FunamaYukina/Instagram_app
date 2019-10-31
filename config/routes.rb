# frozen_string_literal: true

Rails.application.routes.draw do

  root "home#top"
  get "signup" => "users#new"
  post "signup" => "users#create"

  get "login" => "session#login_form"
  post "login" => "session#login"
  post "logout" => "session#logout"

  get "users/:id" => "users#show", as: "user_page"
  get "profile/:id" => "users#edit", as: "profile"
  patch "profile/:id" => "users#update", as: nil

  post "users/:id/posts/create" => "posts#create", as: "post"

  get "images/index"
end