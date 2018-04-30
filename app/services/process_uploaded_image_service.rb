class ProcessUploadedImageService
	attr_reader :image_id

	def initialize(image_id)
		@image = Image.find(image_id)
      	@original_file_name = @image.associated_image.url.split("?")[0].prepend("public")
	end

	def process_image
		tesseract_process_image_find_words

		image = Magick::Image.read(@original_file_name).first
		@words.each do |word_and_position|
		bounding_box = Magick::Draw.new
		bounding_box.fill = "Transparent"
		bounding_box.stroke = 'black'
		bounding_box.stroke_width = 1
		bounding_box.rectangle word_and_position[:x_start], word_and_position[:y_start], word_and_position[:x_end], word_and_position[:y_end]
		bounding_box.draw(image)
		end

		@image.update(marked_up_image: prep_marked_up_image_for_saving(image), hocr_data: @string_of_all_words_in_image)
    end


    private

    def tesseract_process_image_find_words
      tesseract_box = RTesseract::Box.new(@original_file_name)
      @string_of_all_words_in_image = tesseract_box.to_s

      # "words" by default includes dollar amounts, dates, digits, etc.
      @words = tesseract_box.words.keep_if{|w| w[:word].to_f == 0 && w[:word].index("$").nil? && !w[:word].blank?}
    end

    def prep_marked_up_image_for_saving(image)
      image.format = 'PNG'
      file = Paperclip::Tempfile.new(["processed", ".png"])
      file.path
      image.write(file.path)

      file = File.open(file.path)
      file
    end

end
