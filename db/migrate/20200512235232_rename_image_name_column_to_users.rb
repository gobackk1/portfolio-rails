class RenameImageNameColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :image_name, from: "default.png", to: "/images/default.png"
    rename_column :users, :image_name, :image_url
  end
end
