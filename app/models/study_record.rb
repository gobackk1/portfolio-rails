class StudyRecord < ApplicationRecord
  def user
    User.find(self.user_id)
  end
end
