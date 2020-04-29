class UsersController < ApplicationController
  skip_before_action :authenticate!, only: [:login, :create]

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      render json: {
        name: @user.name,
        token: @user.token,
        created_at: @user.created_at
      }
    else
      render json: {errors: ['ログインに失敗しました']}, status: 401
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: {
        name: @user.name,
        token: @user.token,
        created_at: @user.created_at
      }
    else
      render json: {errors: @user.errors.full_messages}, status: 400
    end
  end

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  private
    def user_params
      params.permit(:name, :email, :password)
    end
end
