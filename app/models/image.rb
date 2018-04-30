class Image < ApplicationRecord
	# original_uploaded_image
	has_attached_file :associated_image
	has_attached_file :marked_up_image

	validates_attachment :associated_image, presence: true
	validates_attachment_content_type :associated_image, content_type: /\Aimage/
	validates_attachment_file_name :associated_image, matches: [/png\z/]

	validates_attachment_content_type :marked_up_image, content_type: /\Aimage/
	validates_attachment_file_name :marked_up_image, matches: [/png\z/]

end
