class LikesController < ApplicationController
  before_action :current_user

  def create
    like = Like.new(like_params)
    like.user_id = @current_user.id
    if like.save
      likes = Like.where(study_record_id: params[:study_record_id])
      render json: {
        count: likes.count,
        isLiked: true
      }
    else
      render json: {message: like.errors.fullmessages}
    end
  end

  def destroy
    like = Like.find_by(user_id: @current_user.id, study_record_id: params[:id])
    if like.destroy
      likes = Like.where(study_record_id: params[:id])
      render json: {
        count: likes.count,
        isLiked: false
      }
    else
      render json: {message: like.errors.fullmessages}
    end
  end

  def all
    render json: {
      count: Like.where(study_record_id: params[:id]).count,
      isLiked: !Like.find_by(user_id: @current_user.id, study_record_id: params[:id]).nil?
    }
  end

  private
    def like_params
      params.permit(:study_record_id)
    end
end
