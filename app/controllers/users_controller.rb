class UsersController < ApplicationController
  skip_before_action :authenticate!, only: [:login, :create]
  before_action :current_user, only: [:update, :show, :report, :index, :search]

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      render json: process_user_for_auth(user)
    else
      render json: {messages: ['メールアドレスかパスワードが間違っているようです。もう一度入力してください。']}, status: 401
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: process_user_for_auth(user)
    else
      render json: {messages: user.errors.full_messages}, status: 401
    end
  end

  def index
    selected_users = User.where.not(id: @current_user.id).pager(page: params[:page].to_i, per: params[:per].to_i).select(:id, :name, :image_url, :user_bio, :created_at)
    users = selected_users.map do |user|
      process_user_for_response user
    end
    sleep 0.2
    render json: {users: users, not_found: false}
  end

  def show
    @user = User.find(params[:id])
    sleep 0.2
    data = process_user_for_response @user
    render json: data
  end

  def update
    @user = User.find(params[:id])
    @user.user_bio = params[:user_bio]
    # TODO: 後で見直す
    if @current_user.id == params[:id].to_i
      if params[:image_select]
        FileUtils.rm_rf("public/api/images/user_images/#{@user.id}")
        @user.image_url = "/images/user_images/#{@user.id}/#{@user.id}-#{Time.now.to_i}.jpg"
        image = params[:image_select]
        Dir.mkdir("public/api/images/user_images/#{@user.id}")
        File.binwrite("public/api/#{@user.image_url}", Base64.decode64(image))
      end
      if @user.save
        result = process_user_for_response @user
        render json: result
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
    # NOTE: Book::ActiveRecord_Relation にはscopeが使えない？
    keyword = params[:keyword]
    num = params[:page].to_i.positive? ? params[:page].to_i - 1 : 0
    per = params[:per]
    users = User.where.not(id: @current_user.id).where("name LIKE ? OR user_bio LIKE ?", "%#{keyword}%", "%#{keyword}%")
    return render json: {users: [],messages: ['ユーザーが見つかりませんでした。別のキーワードで検索してください。'], not_found: true} if users.size == 0
    limited_users = users.limit(per).offset(per * num).select(:id, :name, :image_url, :user_bio, :created_at)
    result = limited_users.map do |user|
      process_user_for_response user
    end
    render json: {users: result, not_found: false}
  end

  private
    def user_params
      params.permit(:name, :email, :password)
    end

    def process_user_for_auth(user)
      {
        id: user.id,
        name: user.name,
        token: user.token,
      }
    end
end
