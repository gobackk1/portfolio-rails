class UsersController < ApplicationController
  skip_before_action :authenticate!, only: [:login, :create]
  before_action :current_user, only: [:update]

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      render json: {
        id: @user.id,
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
        id: @user.id,
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
    render_profile @user
  end

  def update
    @user = User.find(params[:id])
    @user.user_bio = params[:user_bio]
    if @current_user.id == params[:id].to_i
      if params[:image]
        @user.image_name = "#{@user.id}.jpg"
        image = params[:image]
        File.binwrite("public/api/images/user_images/#{@user.image_name}", Base64.decode64(image))
      end
      if @user.save
        render_profile @user
      else
        render json: {message: @user.errors.full_messages, user: @user}
      end
    else
      render json: {message: 'ログインしてください'}
    end
  end

  private
    def user_params
      params.permit(:name, :email, :password)
    end

    def render_profile(user)
      study_records = StudyRecord.where(user_id: user.id)
      total_study_hours = study_records.sum(:study_hours)
      render json: {
        user: user,
        study_records: study_records,
        total_study_hours: total_study_hours
      }
    end
end
