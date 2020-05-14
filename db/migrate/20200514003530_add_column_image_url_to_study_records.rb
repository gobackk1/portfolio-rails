class AddColumnImageUrlToStudyRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :study_records, :image_url, :string, default: nil
  end
end
