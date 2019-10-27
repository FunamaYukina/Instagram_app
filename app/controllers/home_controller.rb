# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.all
    @posts = Post.all
    @post = current_user.posts.build if current_user
    @images = Image.all
  end
end
