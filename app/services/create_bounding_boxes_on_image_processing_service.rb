# class ProcessIntoMarkedUpImage
class CreateBoundingBoxesOnImageProcessingService
	attr_reader :params

	def initialize(params)
		@image = params[:image]
		@search_word_param = params[:search_word].downcase if params[:search_word]

      	@original_file_name = find_file_name	
		@word_data = @search_word_param ? search_hocr_data_for_search_word_param : tesseract_process_image_find_words
	end

	def call
		hocr_data_hash_if_needed = (@search_word_param ? {} : { hocr_data: @word_data.to_json })
		{ marked_up_image: temporarily_store_and_create_file(draw_bounding_boxes_around_words)}.merge(hocr_data_hash_if_needed)
    end


    private

	def find_file_name
		@image.associated_image.url.split("?")[0].prepend("public").gsub("//", "/")
	end

    def tesseract_process_image_find_words
		all_words_dollars_dates_digits_in_image = RTesseract::Box.new(@original_file_name).words
		words = all_words_dollars_dates_digits_in_image.keep_if{ |w| w[:word].to_f == 0 && w[:word].index("$").nil? && !w[:word].blank? }    
    	no_punctuation_or_capitalization_hyphenated_words = words.each{|word_data| word_data[:word] = word_data[:word].downcase.scan(/[a-z]|-/).join }
    end

    def search_hocr_data_for_search_word_param
    	JSON.parse(@image.hocr_data).keep_if{ |word_data| word_data["word"] == @search_word_param } rescue []
    end

    def draw_bounding_boxes_around_words
		image = Magick::Image.read(@original_file_name).first
		
		if @word_data.present?
			@word_data.each do |word_and_position|
				bounding_box = Magick::Draw.new
				bounding_box.fill = "Transparent"
				bounding_box.stroke = 'black'
				bounding_box.stroke_width = 1
				if @search_word_param
					bounding_box.rectangle word_and_position["x_start"], word_and_position["y_start"], word_and_position["x_end"], word_and_position["y_end"]
				else
					bounding_box.rectangle word_and_position[:x_start], word_and_position[:y_start], word_and_position[:x_end], word_and_position[:y_end]
				end
				bounding_box.draw(image)
			end
		end

		image
	end

    def temporarily_store_and_create_file(image=nil)
    	if @search_word_param
    		file = File.new("#{Rails.root}/app/assets/images/temporary_uploads/search_results_#{@image.id}.png",'w')
    	else
			image.format = 'PNG'    	
	    	file = Paperclip::Tempfile.new(["processed", ".png"])
    	end
		image.write(file.path) 
    	File.open(file.path)
    end

end
