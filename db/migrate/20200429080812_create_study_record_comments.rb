class CreateStudyRecordComments < ActiveRecord::Migration[5.2]
  def change
    create_table :study_record_comments do |t|
      t.references :study_record, foreign_key: true
      t.integer :user_id
      t.text :comment_body
      t.timestamps
    end
  end
end
