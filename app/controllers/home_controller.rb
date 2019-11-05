# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.eager_load([:posts, posts: :images]).order("posts.created_at desc")
    # binding.pry
    @post = current_user.posts.build if logged_in?
  end
end
