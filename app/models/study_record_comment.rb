class StudyRecordComment < ApplicationRecord
  belongs_to :study_record
  belongs_to :user
end
