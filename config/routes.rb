# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#top"
  get "signup" => "users#new"
  post "signup" => "users#create"

  get "login" => "session#login_form"
  post "login" => "session#login"
  post "logout" => "session#logout"

  scope "users/:username" do
    get "/" => "users#show", as: "user"
    post "posts" => "posts#create", as: "posts"
    post "posts/:post_id/like" => "likes#like", as: "like"
    delete "posts/:post_id/unlike" => "likes#unlike", as: "unlike"
    post "relationships" => "relationships#follow", as: "follow"
    delete "relationships" => "relationships#unfollow", as: "unfollow"
  end
  scope "settings" do
    get "profile" => "profiles#edit"
    patch "profile" => "profiles#update"
    get "password" => "passwords#edit"
    patch "password" => "passwords#update"
  end
end
