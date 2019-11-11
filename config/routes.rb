# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#top"
  get "signup" => "users#new"
  post "signup" => "users#create"

  get "login" => "session#login_form"
  post "login" => "session#login"
  post "logout" => "session#logout"

  get "users/:username" => "users#show", as: "user"

  post "users/:username/posts" => "posts#create", as: "posts"

  post   "/like/:post_id" => "likes#like",   as: "like"
  delete "/like/:post_id" => "likes#unlike", as: "unlike"
  scope "settings" do
    get "profile" => "profiles#edit"
    patch "profile" => "profiles#update"
    get "password" => "passwords#edit"
    patch "password" => "passwords#update"
  end
end
