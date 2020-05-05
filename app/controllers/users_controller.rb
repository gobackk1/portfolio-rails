class UsersController < ApplicationController
  skip_before_action :authenticate!, only: [:login, :create]
  before_action :current_user, only: [:update, :show, :report]

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
    @users = User.select(:id, :name, :image_name, :user_bio)
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

  def report
    from = Time.now.at_beginning_of_day
    to = (from + 6.day).at_end_of_day
    total_records = @current_user.study_records
    weekly_records = total_records.where(created_at: from...to)
    study_time_per_week = weekly_records.map do |record|
      {
        date: I18n.l(record.created_at, format: :date),
        study_hour: record.study_hours
      }
    end

    teaching_materials = weekly_records.select(:teaching_material).distinct.map do |material|
      material.teaching_material
    end
    report_by_teaching_material =[]
    teaching_materials.map do |material|
      study_hours = weekly_records.where(teaching_material: material).sum(:study_hours)
      report_by_teaching_material << {teaching_material: material, study_hours: study_hours}
    end

    render json: {
      study_hours: {
        today: weekly_records.where(created_at: from...Time.now.at_end_of_day).sum(:study_hours),
        week: weekly_records.sum(:study_hours),
        total: total_records.sum(:study_hours)
      },
      study_time_per_week: study_time_per_week,
      report_by_teaching_material: report_by_teaching_material
    }
  end

  def search
    keyword = params[:keyword]
    users = User.where("name LIKE ? OR user_bio LIKE ?", "%#{keyword}%", "%#{keyword}%").select(:id, :name, :image_name, :user_bio)
    render json: users
  end

  private
    def user_params
      params.permit(:name, :email, :password)
    end

    def render_profile(user)
      study_records = StudyRecord.where(user_id: user.id)
      total_study_hours = study_records.sum(:study_hours)
      followings_count = user.followings.count
      followers_count = user.followers.count
      render json: {
        user: user,
        study_records: study_records,
        total_study_hours: total_study_hours,
        followings_count: followings_count,
        followers_count: followers_count,
        is_following: @current_user.following?(user)
      }
    end
end
