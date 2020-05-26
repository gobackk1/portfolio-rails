class RelationshipsController < ApplicationController
  before_action :current_user
  before_action :set_user

  def create
    following = @current_user.follow(@user)
    if following.save
      result = process_user_for_response @user
      render json: result
    else
      render json: {message: 'ユーザーのフォローに失敗しました'}
    end
  end

  def destroy
    following = @current_user.unfollow(@user)
    # TODO: もう一度Destroyする理由を調べる
    if following.destroy
      result = process_user_for_response @user
      render json: result
    else
      render json: {message: 'フォロー解除に失敗しました'}
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
