class UsersController < ApplicationController
  skip_before_action :authenticate!, only: [:login, :create]
  before_action :current_user, only: [:update, :show, :report, :index, :search]

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      render json: process_user_for_response(user)
    else
      render json: {messages: ['メールアドレスかパスワードが間違っているようです。もう一度入力してください。']}, status: 401
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: process_user_for_response(user)
    else
      render json: {messages: user.errors.full_messages}, status: 401
    end
  end

  def index
    selected_users = User.where.not(id: @current_user.id).select(:id, :name, :image_name, :user_bio)
    users = selected_users.map do |user|
      {
        id: user.id,
        name: user.name,
        image_name: user.image_name,
        user_bio: user.user_bio,
        is_following: @current_user.following?(user)
      }
    end
    render json: users
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
    # to = (from - 6.day).at_end_of_day
    current_user_records = @current_user.study_records
    study_time_per_week = []

    (0..6).to_a.map do |i|
      study_time_per_week << {
        date: I18n.l(Time.now - (6 - i).days, format: "%m月%d日"),
        study_hour: current_user_records.where(created_at: (6 - i).day.ago.all_day).sum(:study_hours)
      }
    end

    teaching_materials = current_user_records.select(:teaching_material).distinct.map do |material|
      material.teaching_material
    end
    report_by_teaching_material =[]
    teaching_materials.map do |material|
      study_hours = current_user_records.where(teaching_material: material).sum(:study_hours)
      report_by_teaching_material << {teaching_material: material, study_hours: study_hours}
    end
    report_by_teaching_material.sort! do |a,b|
      b[:study_hours] <=> a[:study_hours]
    end

    render json: {
      study_hours: {
        today: current_user_records.where(created_at: from...Time.now.at_end_of_day).sum(:study_hours),
        week: current_user_records.sum(:study_hours),
        total: current_user_records.sum(:study_hours)
      },
      study_time_per_week: study_time_per_week,
      report_by_teaching_material: report_by_teaching_material,
    }
  end

  def search
    keyword = params[:keyword]
    users = User.where.not(id: @current_user.id).where("name LIKE ? OR user_bio LIKE ?", "%#{keyword}%", "%#{keyword}%").select(:id, :name, :image_name, :user_bio)
    render json: users
  end

  private
    def user_params
      params.permit(:name, :email, :password)
    end

    def process_user_for_response(user)
      {
        id: user.id,
        name: user.name,
        token: user.token,
      }
    end

    def render_profile(user)
      study_records = user.study_records
      results = study_records.map do |record|
        process_record_for_response(record)
      end
      total_study_hours = study_records.sum(:study_hours)
      followings_count = user.followings.count
      followers_count = user.followers.count
      render json: {
        user: user,
        registered_date: I18n.l(user.created_at, format: '%Y/%m/%d'),
        study_records: results,
        total_study_hours: total_study_hours,
        followings_count: followings_count,
        followers_count: followers_count,
        is_following: @current_user.following?(user)
      }
    end
end
