class StudyRecordsController < ApplicationController
  before_action :current_user

  def index
    @records = StudyRecord.all.to_json(include: [:study_record_comments])
    render json: @records
  end

  def show
    @record = StudyRecord.find(params[:id]).to_json(include: [:study_record_comments])
    render json: @record
  end

  def create
    @record = StudyRecord.new(study_record_params)
    @record.user_id = @current_user.id

    if @record.save
      render json: @record
    else
      render json: {errors: @record.errors.full_message}
    end
  end

  def update
    @record = StudyRecord.find(params[:id])
    @record.update_attributes(
      comment: params[:comment],
      teaching_material: params[:teaching_material],
      study_hours: params[:study_hours],
      tag_liset: params[:tag_list]
    )
    if @record.save
      render json: @record
    else
      render json: {errors: @record.errors.full_message}
    end
  end

  def destroy
    StudyRecord.find(params[:id]).destroy
    render json: params[:id]
  end

  def search
    keyword = params[:keyword]
    records = StudyRecord.where("comment LIKE ? OR teaching_material LIKE ?", "%#{keyword}%", "%#{keyword}%")
    render json: records
  end

  private
    def study_record_params
      params.permit(:comment, :teaching_material, :study_hours, :study_genre_list)
    end
end
