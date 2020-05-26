class StudyRecordsController < ApplicationController
  before_action :current_user

  def index
    if params[:user_id]
      records = StudyRecord.where(user_id: params[:user_id].to_i).pager(page: params[:page].to_i, per: params[:per].to_i).order(id: :DESC)
    else
      records = StudyRecord.pager(page: params[:page].to_i, per: params[:per].to_i).order(id: :DESC)
    end
    result = records.map do |record|
      process_record_for_response(record)
    end
    sleep 0.2
    render json: {result: result, not_found: false}
  end

  def show
    record = StudyRecord.find(params[:id])
    render json: process_record_for_response(record)
  end

  def create
    record = StudyRecord.new(study_record_params)
    record.user_id = @current_user.id
    record.image_url = params[:image_url] if params[:image_url]

    if record.save
      if params[:image_select]
        set_image record, params[:image_select]
      end
      render json: process_record_for_response(record)
    else
      render json: {messages: record.errors.full_message}
    end
  end

  def update
    record = StudyRecord.find(params[:id])
    record.update_attributes(
      comment: params[:comment],
      teaching_material_name: params[:teaching_material_name],
      study_hours: params[:study_hours],
      study_genre_list: params[:study_genre_list]
    )
    if record.save
      if params[:image_select]
        FileUtils.rm_rf "public/api/images/user_images/#{record.user_id}/study_records/#{record.id}"
        set_image record, params[:image_select]
      end
      render json: process_record_for_response(record)
    else
      render json: {messages: record.errors.full_message}
    end
  end

  def destroy
    StudyRecord.find(params[:id]).destroy
    render json: params[:id]
  end

  def search
    # NOTE: Book::ActiveRecord_Relation にはscopeが使えない？
    keyword = params[:keyword]
    num = params[:page].to_i.positive? ? params[:page].to_i - 1 : 0
    per = params[:per]
    records = StudyRecord.where("comment LIKE ? OR teaching_material_name LIKE ?", "%#{keyword}%", "%#{keyword}%")
    return render json: {result: [], messages: ['勉強記録が見つかりませんでした。別のキーワードで検索してください。'], not_found: true} if records.size == 0
    limited_records = records.limit(per).offset(per * num).order(id: :DESC)
    result = limited_records.map do |record|
      process_record_for_response(record)
    end
    render json: {result: result, not_found: false}
  end

  private
    def study_record_params
      params.permit(:comment, :teaching_material_name, :study_hours, :study_genre_list)
    end

    def set_image(record, image)
      path = "/images/user_images/#{record.user_id}/study_records"
      record.update_attribute(:image_url, "#{path}/#{record.id}/#{Time.now.to_i}.jpg")
      FileUtils.mkdir_p("public/api/#{path}/#{record.id}")
      File.binwrite("public/api/#{record.image_url}", Base64.decode64(params[:image_select]))
    end
end
