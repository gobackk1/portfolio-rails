class TeachingMaterial < ApplicationRecord
  belongs_to :user
  has_many :study_records, dependent: :destroy
end
