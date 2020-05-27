class AddReferenceStudyRecordsToTeachingMaterials < ActiveRecord::Migration[5.2]
  def change
    add_reference :teaching_materials, :study_record, foreign_key: true
    add_reference :study_records, :teaching_material, foreign_key: true
    rename_column :study_records, :teaching_material, :teaching_material_name
  end
end
