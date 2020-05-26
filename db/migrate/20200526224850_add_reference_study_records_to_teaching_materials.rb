class AddReferenceStudyRecordsToTeachingMaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :teaching_materials, :study_record_id, :integer
    add_column :study_records, :teaching_material_id, :integer
    rename_column :study_records, :teaching_material, :teaching_material_name
  end
end
