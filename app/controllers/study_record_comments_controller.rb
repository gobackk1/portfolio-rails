class StudyRecordCommentsController < ApplicationController
  before_action :current_user

  def create
    record = StudyRecord.find(params[:study_record_id])
    comment = record.study_record_comments.new(comment_params)
    comment.user_id = @current_user.id

    if comment.save
      render json: comment
    else
      render json: {errors: comment.errors.full_message}
    end
  end

  def destroy
    record = StudyRecord.find(params[:study_record_id])
    comment = record.study_record_comments.find(params[:id])

    if comment.user_id == @current_user.id
      comment.destroy
      render json: params[:id]
    else
      render json: params[:id], status: 401
    end
  end

  private
    def comment_params
      params.permit(:comment_body)
    end
end
