class User < ApplicationRecord
  before_save :downcase_email
  has_secure_token
  has_secure_password
  has_many :study_records, dependent: :destroy
  has_many :study_record_comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :teaching_materials

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {in: 6..50}, uniqueness: true
  validates :email, presence: true ,uniqueness: {case_sensitive: true}, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true, length: {in: 6..50}, allow_nil: true
  validates :token, uniqueness: true

  def downcase_email
    self.email.downcase!
  end

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
end
