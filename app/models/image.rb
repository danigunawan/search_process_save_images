class Image < ApplicationRecord
	# belongs_to :unprocessed_image, class_name: "Image", foreign_key: "associated_image_id", optional: true
	# has_one :marked_up_image, class_name: "Image", foreign_key: "associated_image_id"

	has_attached_file :associated_image

	validates_attachment :associated_image, presence: true
	# Validate content type
	validates_attachment_content_type :associated_image, content_type: /\Aimage/
	# Validate filename
	validates_attachment_file_name :associated_image, matches: [/png\z/]

end
