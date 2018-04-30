class AddForeignKeyToImages < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :images, :marked_up_image
  	rename_column :images, :file_name, :description
  end
end
