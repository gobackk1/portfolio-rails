class StudyRecordCommentsController < ApplicationController
  include CommonModule

  before_action :current_user

  def create
    record = StudyRecord.find(params[:study_record_id])
    comment = record.study_record_comments.new(comment_params)
    comment.user_id = @current_user.id

    if comment.save
      render json: process_comment_for_response(comment)
    else
      render json: {errors: comment.errors.full_message}
    end
  end

  def destroy
    record = StudyRecord.find(params[:study_record_id])
    comment = record.study_record_comments.find(params[:id])

    if comment.user_id == @current_user.id
      comment.destroy
      render json: {
        id: params[:id].to_i,
        study_record_id: params[:study_record_id].to_i
      }
    else
      render json: params[:id], status: 401
    end
  end

  private
    def comment_params
      params.permit(:comment_body)
    end
end
