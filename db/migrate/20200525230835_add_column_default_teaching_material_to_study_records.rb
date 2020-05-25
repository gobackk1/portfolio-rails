class AddColumnDefaultTeachingMaterialToStudyRecords < ActiveRecord::Migration[5.2]
  def change
    change_column_default :study_records, :image_url, from: "", to: "/images/default.png"
  end
end
