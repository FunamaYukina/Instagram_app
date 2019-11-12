# frozen_string_literal: true
class LikesController < ApplicationController
  before_action :set_variables
  before_action :authenticated_user

  def like
    current_user.like_post(@post.id)
  end

  def unlike
    current_user.unlike_post(@post.id)
  end

  private

  def set_variables
    @post = Post.find(params[:post_id])
    @id = "#like-link-#{@post.id}"
  end

  def authenticated_user
    return if logged_in?

    flash[:danger] = "ログインしてください"
    redirect_to login_path
  end
end
