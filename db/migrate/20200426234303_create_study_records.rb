class CreateStudyRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :study_records do |t|
      t.integer :user_id
      t.text :comment
      t.string :teaching_material
      t.float :study_hours
      t.timestamps
    end
  end
end
