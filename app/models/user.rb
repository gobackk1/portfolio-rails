class User < ApplicationRecord
  has_secure_token
  has_secure_password

  validates :email, presence: true ,uniqueness: {case_sensitive: true}
  validates :name, presence: true
  validates :password_digest, presence: true
  validates :token, uniqueness: true
end
