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

  def process_record_for_response(record)
    comments = record.study_record_comments.map do |c|
      process_comment_for_response(c)
    end
    {
      id: record.id,
      user: {
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
