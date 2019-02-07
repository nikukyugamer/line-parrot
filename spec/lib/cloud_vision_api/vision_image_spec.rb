require 'rails_helper'

RSpec.describe CloudVisionApi::VisionImage do
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
      it 'create object correctly' do
        image_object = CloudVisionApi::VisionImage.new(filepath[:nyalan_face])
        expect(image_object.is_a?(CloudVisionApi::VisionImage)).to be true
      end
    end

    describe '#safe_search' do
      context 'Is a cat image adult?' do
        it 'return false' do
          expect(@nyalan_image_object.safe_search.adult?.is_a?(FalseClass)).to be true
        end
      end

      context 'Is an adult figure adult?' do
        it 'return true' do
          expect(@adult_figure_image_object.safe_search.adult?.is_a?(TrueClass)).to be true
        end
      end
    end

    describe '#document_text' do
      pending 'OCR test'
    end

    describe '#landmark' do
      pending 'Pick up ONE landmark test'
    end

    describe '#landmarks' do
      pending 'Pick up some landmarks test'
    end

    describe '#logo' do
      pending 'Pick up ONE logo test'
    end

    describe '#logos' do
      pending 'Pick up some logos test'
    end
  end
end
