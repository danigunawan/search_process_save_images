require 'rack/test'

Fabricator(:image) do
  description "MyString"
  hocr_data "MyText"

  associated_image { Rack::Test::UploadedFile.new('spec/fabricators/assets/sample_user_png.png', 'image/png') }
end
