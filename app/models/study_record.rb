class StudyRecord < ApplicationRecord
  has_many :study_record_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user
  acts_as_taggable_on :study_genres

  def user
    User.find(self.user_id)
  end
end
