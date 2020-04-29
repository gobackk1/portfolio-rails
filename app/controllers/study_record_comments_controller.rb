class StudyRecordCommentsController < ApplicationController
  before_action :current_user

  def create
    comment = StudyRecordComment.new(comment_params)
    comment.user_id = @current_user.id

    if comment.save
      render json: comment
    else
      render json: {errors: comment.errors.full_message}
    end
  end

  def destroy
    StudyRecordComment.find(params[:id]).destroy
    render json: params[:id]
  end

  private
    def comment_params
      params.permit(:comment_body, :study_record_id)
    end
end
