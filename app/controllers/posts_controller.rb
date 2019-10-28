# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @post = Post.new
  end

  def new
    @post = Post.new
    @post.images.build
  end

  def create
    check_logged_in?
    # binding.pry
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿を作成しました"
      root_path and return
    else
      render("posts/new")
    end
  end

  private

    def post_params
      params.require(:post).permit(:message, [images_attributes: %i[image_file post_id]])
    end
end
