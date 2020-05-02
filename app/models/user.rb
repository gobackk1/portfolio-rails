class User < ApplicationRecord
  before_save :downcase_email
  has_secure_token
  has_secure_password
  has_many :study_records, dependent: :destroy
  has_many :study_record_comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {in: 6..50}
  validates :email, presence: true ,uniqueness: {case_sensitive: true}, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true, length: {in: 6..50}, allow_nil: true
  validates :token, uniqueness: true

  def downcase_email
    self.email.downcase!
  end
end
