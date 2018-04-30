# require 'rmagick'
# include Magick


class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        process_image
        # call service object to process uploaded image
        # save new image, to be called on @image.marked_up_image
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def process_image
      file_name = @image.associated_image.url.split("?")[0].prepend("public")
      tesseract_box = RTesseract::Box.new(file_name)
      @image_string_data = tesseract_box.to_s
      # "words" by default includes dollar amounts, dates, digits, etc.
      @words = tesseract_box.words.keep_if{|w| w[:word].to_f == 0 && w[:word].index("$").nil? && !w[:word].blank?}

      image = Magick::Image.read(file_name).first

      @words.each do |word|
        bounding_box = Magick::Draw.new
        bounding_box.fill = "Transparent"
        bounding_box.stroke = 'black'
        bounding_box.stroke_width = 2
        bounding_box.rectangle word[:x_start], word[:y_start], word[:x_end], word[:y_end]
        bounding_box.draw(image)
      end

      image.format = 'PNG'
      file = Paperclip::Tempfile.new(["processed", ".png"])
      file.path
      image.write(file.path)

      file = File.open(file.path)
      @image.update(marked_up_image: file)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:description, :associated_image)
    end
end
