class Image < ApplicationRecord
	# original_uploaded_image
	has_attached_file :associated_image
	has_attached_file :marked_up_image

	validates_attachment :associated_image, presence: true
	validates_attachment_content_type :associated_image, content_type: /\Aimage/
	validates_attachment_file_name :associated_image, matches: [/png\z/]

	validates_attachment_content_type :marked_up_image, content_type: /\Aimage/
	validates_attachment_file_name :marked_up_image, matches: [/png\z/]

	after_save :create_marked_up_image_and_hocr_data_attr

	def create_marked_up_image_and_hocr_data_attr
	    self.update_attributes(CreateBoundingBoxesOnImageProcessingService.new(image: self).call) unless self.hocr_data
	end	
end
