# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.eager_load([:posts,posts: :images])
    @post = current_user.posts.build if logged_in?
  end
end
