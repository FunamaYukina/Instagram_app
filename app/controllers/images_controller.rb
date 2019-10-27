# frozen_string_literal: true

class ImagesController < ApplicationController
  def new
    @post = Post.find(params[:post_id])
    @image = Image.new
  end

  def create
    Image.create(image_params)
    redirect_to controller: :posts, action: :create
  end

  private

    def image_params
      params.require(:image).permit(:image_file).merge(post_id: params[:post_id])
    end
end
