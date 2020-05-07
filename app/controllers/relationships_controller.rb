class RelationshipsController < ApplicationController
  before_action :current_user
  before_action :set_user

  def create
    following = @current_user.follow(@user)
    if following.save
      render json: {
        user: {
          id: @user.id,
          is_following: true,
          image_name: @user.image_name,
          name: @user.name,
          user_bio: @user.user_bio
        },
        followers_count: @user.followers.count
      }
    else
      render json: {message: 'ユーザーのフォローに失敗しました'}
    end
  end

  def destroy
    following = @current_user.unfollow(@user)
    # TODO: もう一度Destroyする理由を調べる
    if following.destroy
      render json: {
        user: {
          id: @user.id,
          is_following: false,
          image_name: @user.image_name,
          name: @user.name,
          user_bio: @user.user_bio
        },
        followers_count: @user.followers.count
      }
    else
      render json: {message: 'フォロー解除に失敗しました'}
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
