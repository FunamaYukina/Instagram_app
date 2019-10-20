class UsersController < ApplicationController
  protect_from_forgery


  def new
    @user = User.new
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id

      flash[:notice] = "ログインしました"
      redirect_to home_path
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def create
    @user = User.new(
        email: params[:email],
        full_name: params[:full_name],
        name: params[:name],
        password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      # redirect_to("/users/#{@user.id}")
      redirect_to home_path
    else
      render("users/new")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  private

  def user_params
    params.require(:user).permit(:name, :full_name, :email, :password)
  end


end
