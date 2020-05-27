class StudyRecord < ApplicationRecord
  include CommonModule

  has_many :study_record_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user
  acts_as_taggable_on :study_genres
  belongs_to :teaching_material, optional: true
  # def user
  #   User.find(self.user_id)
  # end
end
