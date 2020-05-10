class AddReferenceTeachingMaterialsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, foreign_key: true
    add_column :teaching_materials, :user_id, :integer
  end
end
