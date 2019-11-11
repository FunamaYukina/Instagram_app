# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.eager_load([:likes, :posts, posts: :images]).order("posts.created_at desc")
    @post = current_user.posts.build if logged_in?
  end
end
