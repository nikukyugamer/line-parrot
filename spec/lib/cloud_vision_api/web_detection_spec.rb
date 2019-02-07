require 'rails_helper'

RSpec.describe CloudVisionApi::WebDetection do
  describe '#instance_methods' do
    let(:filepath) do
      {
        product_description: Rails.root.join(
          'public',
          'sample_images',
          'product_description.png'
        ),
        nyalan_face: Rails.root.join(
          'public',
          'sample_images',
          'nyalan_face.png'
        ),
        adult_figure: Rails.root.join(
          'public',
          'sample_images',
          'nyalan_face.png'
        ),
      }
    end

    before do
      @nyalan_image_object = CloudVisionApi::VisionImage.new(filepath[:nyalan_face])
      @adult_figure_image_object = CloudVisionApi::VisionImage.new(filepath[:adult_figure])
    end

    describe '#initialize' do
      pending 'create object correctly'
      # it 'create object correctly' do
      #   image_object = CloudVisionApi::VisionImage.new(filepath[:nyalan_face])
      #   expect(image_object.is_a?(CloudVisionApi::VisionImage)).to be true
      # end
    end

    describe '#similar_images' do
      pending 'Pick up similar images'
    end

    describe '#best_guess_labels' do
      pending 'Pick up best guess labels'
    end
  end
end
