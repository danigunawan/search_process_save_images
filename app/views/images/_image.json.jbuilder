json.extract! image, :id, :file_name, :hocr_data, :created_at, :updated_at
json.url image_url(image, format: :json)
