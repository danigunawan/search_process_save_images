class AddAssociatedImageToImage < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :images, :associated_image
  end
end
