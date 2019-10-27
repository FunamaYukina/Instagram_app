# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.all
    @posts = Post.all
    @post = current_user.posts.build if current_user
    @images = Image.all
    # @post = current_user.pots.find(params[:id])
    # @user = User.find_by(id: @post.user_id)
  end
end
