class StudyRecord < ApplicationRecord
  has_many :study_record_comments, dependent: :destroy
  belongs_to :user
  def user
    User.find(self.user_id)
  end
end
