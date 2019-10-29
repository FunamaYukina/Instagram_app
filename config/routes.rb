# frozen_string_literal: true

Rails.application.routes.draw do

  get "images/index"

  get "login" => "session#login_form"
  post "login" => "session#login"
  post "logout" => "session#logout"

  get "users/:id" => "users#show", as: "user_page"

  get "posts/index"
  post "post" => "posts#create"

  root "home#top"
  get "signup" => "users#new"
  post "signup" => "users#create"
end
