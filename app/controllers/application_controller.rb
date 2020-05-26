class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate!

  def authenticate!
    authenticate_or_request_with_http_token do |token, options|
      User.find_by(token: token).present?
    end
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'].split[1])
  end

  def process_user_for_response(user)
    study_records = user.study_records
    total_study_hours = study_records.sum(:study_hours)
    followings_count = user.followings.count
    followers_count = user.followers.count
    {
      id: user.id,
      user_bio: user.user_bio,
      image_url: user.image_url,
      name: user.name,
      registered_date: I18n.l(user.created_at, format: '%Y/%m/%d'),
      total_study_hours: total_study_hours,
      followings_count: followings_count,
      followers_count: followers_count,
      is_following: @current_user.following?(user)
    }
  end

  def process_record_for_response(record)
    comments = record.study_record_comments.map do |c|
      process_comment_for_response(c)
    end
    {
      id: record.id,
      user: {
        id: record.user.id,
        image_url: record.user.image_url,
        name: record.user.name
      },
      date: I18n.l(record.created_at),
      record: record,
      comments: comments
    }
  end

  def process_comment_for_response(comment)
    {
      id: comment.id,
      user: {
        image_url: comment.user.image_url,
        name: comment.user.name
      },
      date: I18n.l(comment.created_at),
      comment: comment
    }
  end
end
