class AddColumnImageUrlToTeachingMaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :teaching_materials, :image_url, :string, default: "/images/default.png"
  end
end
