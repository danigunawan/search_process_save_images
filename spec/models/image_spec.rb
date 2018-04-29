require 'rails_helper'

RSpec.describe Image, type: :model do
	let(:no_file_attached) { Fabricate(:image, associated_image: nil) }
	let(:valid_file_attached) { Fabricate(:image) }

	describe 'validations' do
		context 'when file attached is not present or invalid' do
			it 'raises error if no file is attached' do
				expect(Fabricate.build(:image, associated_image: nil)).to_not be_valid
			end
		end
		context 'when valid image is added' do
			it 'creates new image without errors and attaches file' do
				expect(Fabricate.build(:image)).to be_valid
			end
		end
	end
end
