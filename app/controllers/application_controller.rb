class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  include ActionController::Cookies
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
    if record.teaching_material
      record.image_url = record.teaching_material.image_url
      record.teaching_material_name = record.teaching_material.title
    end
    {
      id: record.id,
      date: I18n.l(record.created_at),
      record_comment: record.record_comment,
      study_hours: record.study_hours,
      image_url: record.image_url,
      study_genre_list: record.study_genre_list,
      teaching_material_id: record.teaching_material_id,
      teaching_material_name: record.teaching_material_name,
      created_at: record.created_at,
      updated_at: record.updated_at,
      comments: comments,
      user: {
        id: record.user.id,
        image_url: record.user.image_url,
        name: record.user.name
      },
    }
  end

  def process_comment_for_response(comment)
    {
      id: comment.id,
      date: I18n.l(comment.created_at),
      comment_body: comment.comment_body,
      created_at: comment.created_at,
      study_record_id: comment.study_record_id,
      updated_at: comment.updated_at,
      user: {
        id: comment.user.id,
        image_url: comment.user.image_url,
        name: comment.user.name
      },
    }
  end
end
