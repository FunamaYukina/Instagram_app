# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.eager_load([:likes, :posts, posts: :images])
    @post = current_user.posts.build if current_user
    @user = current_user
  end
end
