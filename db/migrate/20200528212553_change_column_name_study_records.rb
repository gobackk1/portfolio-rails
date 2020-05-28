class ChangeColumnNameStudyRecords < ActiveRecord::Migration[5.2]
  def change
    rename_column :study_records, :comment, :record_comment
  end
end
