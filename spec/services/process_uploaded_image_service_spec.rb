require 'rails_helper'

RSpec.describe ProcessUploadedImageService do
	let(:image_params) { Fabricate.to_params(:image) }

	describe 'process_image' do
		context 'with valid input of image with attached file' do
			# it 'attaches marked up image' do
			# 	@image = Image.create!(image_params)
			# 	ProcessUploadedImageService.new(@image.id).process_image
			# 	expect(@image.marked_up_image).to_not be_nil
			# end
			# it 'sets hocr_data attribute to words in image' do
			# 	@image = Image.create(image_params)
			# 	ProcessUploadedImageService.new(@image.id).process_image
			# 	expect(@image.hocr_data).to eq("")
			# end
		end
	end
end