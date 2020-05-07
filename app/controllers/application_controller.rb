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
    {
      id: record.id,
      user: {
        image_name: record.user.image_name,
        name: record.user.name
      },
      date: I18n.l(record.created_at),
      record: record,
    }
  end
end
