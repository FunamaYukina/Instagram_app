class PostsController < ApplicationController
  def index
  end

  def create
    @post = Post.new(
        user_id: @current_user.id,
        message: params[:message]
    )
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to home_path
    else
      render("posts/new")
    end
  end
end
