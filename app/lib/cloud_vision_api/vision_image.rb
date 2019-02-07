# https://googleapis.github.io/google-cloud-ruby/docs/google-cloud-vision/latest/Google/Cloud/Vision/Image.html

require 'google/cloud/vision'

class CloudVisionApi::VisionImage
  def initialize(filepath)
    vision = Google::Cloud::Vision.new
    @image = vision.image(filepath)
  end

  def safe_search
    @image.safe_search
  end

  def document_text
    @image.text
  end

  def landmark
    @image.landmark
  end

  def landmarks
    @image.landmarks
  end

  def logo
    @image.logo
  end

  def logos
    @image.logos
  end
end
