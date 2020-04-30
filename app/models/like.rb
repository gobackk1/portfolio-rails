class Like < ApplicationRecord
  belongs_to :user
  belongs_to :study_record
  validates :user_id, presence: true
  validates :study_record_id, presence: true
end
