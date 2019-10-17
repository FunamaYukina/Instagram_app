class HomeController < ApplicationController
  def top
    @users = User.all
  end
end
