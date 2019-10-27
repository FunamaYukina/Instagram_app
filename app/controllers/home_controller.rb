# frozen_string_literal: true

class HomeController < ApplicationController
  def top
    @users = User.all
  end
end
