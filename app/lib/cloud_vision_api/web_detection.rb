require 'google/cloud/vision'

class CloudVisionApi::WebDetection
  def initialize(filepath)
    image_annotator_client = Google::Cloud::Vision::V1.new # (version: :v1)

    image_content = File.open(filepath, 'r')
    image = { content: image_content }

    type = :WEB_DETECTION
    features_element = { type: type }
    features = [features_element]

    requests_element = { image: image, features: features }
    requests = [requests_element]
    batch_responses = image_annotator_client.batch_annotate_images(requests)

    # batch_responses.responses is Class: Google::Protobuf::RepeatedField
    # image_response is Class: Google::Cloud::Vision::V1::AnnotateImageResponse
    # https://googleapis.github.io/google-cloud-ruby/docs/google-cloud-vision/latest/Google/Cloud/Vision/V1/AnnotateImageResponse.html
    image_response = batch_responses.responses[0]

    # https://googleapis.github.io/google-cloud-ruby/docs/google-cloud-vision/latest/Google/Cloud/Vision/V1/WebDetection.html
    @web_detection = image_response.web_detection
  end

  def similar_images
    @web_detection.visually_similar_images # Array
  end

  def best_guess_labels
    @web_detection.best_guess_labels # Array
  end
end
