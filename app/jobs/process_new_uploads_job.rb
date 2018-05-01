class ProcessNewUploadsJob < ApplicationJob
  include SuckerPunch::Job
  queue_as :default

  def perform(image)
  	image.update_attributes(CreateBoundingBoxesOnImageProcessingService.new(image: image).call)
  end
end
