# TODO: TOOOOOOOOO FAT CONTROLLER
# require 'line/bot' must be written explicitly
require 'line/bot'

class LineMeController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :validate_signature, only: [:messaging_api]

  # 外部からの Webhooks を受ける
  def messaging_api
    body = request.body.read
    events = @line_api_client.parse_events_from(body)

    # TODO: Fat過ぎ
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if /\A([a-zA-Z0-9]+)\z/ =~ event.message['text']
            message = {
              type: 'text',
              text: 'a-zA-z0-9!!!',
            }
          elsif event.message['text'] == 'おはよう'
            message = {
              type: 'image',
              originalContentUrl: "#{ENV['APP_HOST']}/reply_files/images/origin/foobar.png",
              previewImageUrl: "#{ENV['APP_HOST']}/reply_files/images/thumbnail/foobar_thumbnail.png",
            }
          elsif event.message['text'] == 'こんにちは'
            message = {
              type: 'image',
              originalContentUrl: "#{ENV['APP_HOST']}/reply_files/images/origin/foobar.jpg",
              previewImageUrl: "#{ENV['APP_HOST']}/reply_files/images/thumbnail/foobar_thumbnail.jpg",
            }
          elsif event.message['text'] == 'こんばんは'
            message = {
              type: 'image',
              originalContentUrl: "#{ENV['APP_HOST']}/reply_files/images/origin/foobar.jpg",
              previewImageUrl: "#{ENV['APP_HOST']}/reply_files/images/thumbnail/foobar_thumbnail.jpg",
            }
          elsif !(ReactionWord.reply_record(event.message['text'])).nil?
            reply_text = ReactionWord.reply_record(event.message['text']).reply_message
            message = {
              type: 'text',
              text: reply_text,
            }
          else
            message = {
              type: 'text',
              text: "#{event.message['text']}ってなんですかぁ？",
            }
          end
        when Line::Bot::Event::MessageType::Image
          response = @line_api_client.get_message_content(event.message['id'])

          filename_without_ext = Time.zone.now.strftime('%Y%m%d_%H%M%S')
          filepath_for_tmp_save = Rails.root.join('public', 'recieved_files', filename_without_ext)

          # どうやらユーザが POST した時点で強制的にすべて JPEG に変わるっぽい……
          File.binwrite(filepath_for_tmp_save, response.body)
          filepath_for_save = Rails.root.join(
            'public',
            'recieved_files',
            "#{filename_without_ext}.#{image_format_type(filepath_for_tmp_save)}"
          )
          File.rename(filepath_for_tmp_save, filepath_for_save)

          # TODO: FAT CONTROLLERRRRRRRR
          # Vision API
          image_object = CloudVisionApi::VisionImage.new(filepath_for_save)
          web_detection = CloudVisionApi::WebDetection.new(filepath_for_save)
          recommend_image_uris = []
          web_detection.similar_images.each do |similar_image|
            recommend_image_uris << similar_image.url
          end

          similar_images_list_text = ''
          recommend_image_uris.each_with_index do |image_uri, i|
            break if i > 4
            similar_images_list_text += "#{image_uri}\n\n"
          end

          # TODO: 外に出すべき
          similar_images_list_text = similar_images_list_text.empty? ? '※見つかりませんでした' : similar_images_list_text.rstrip!
          landmark_info = image_object.landmark.nil? ? '※見つかりませんでした' : image_object.landmark
          brand_logo_info = image_object.logo.nil? ? '※見つかりませんでした' : image_object.logo.description
          text_scan_info = image_object.document_text.nil? ? '※見つかりませんでした' : image_object.document_text

          response_text = <<~DOC
            この画像の内容はズバリ、#{web_detection.best_guess_labels[0].label} ですね！

            この画像に似た画像は以下のとおりです♪
              #{similar_images_list_text}

            その他のこの画像の情報は以下のとおりです♪

            成人向けか: #{boolean_english_to_japanese(image_object.safe_search.adult?)}
            暴力的か: #{boolean_english_to_japanese(image_object.safe_search.violence?)}
            ランドマーク情報: #{landmark_info}
            ブランドロゴ情報: #{brand_logo_info}
            テキストスキャン:
            #{text_scan_info}
          DOC
          response_text.rstrip!

          message = {
            type: 'text',
            text: response_text,
          }
        when Line::Bot::Event::MessageType::Sticker
          message = {
            type: 'text',
            text: '素敵なスタンプですね☆',
          }
        else
          message = {
            type: 'text',
            text: 'あみこです☆',
          }
        end

        @line_api_client.reply_message(event['replyToken'], message)
      end
    end

    'OK'
  end

  private
  def validate_signature
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless line_api_client.validate_signature(body, signature)
      error 400 do
        'Bad Request'
      end
    end
  end

  def line_api_client
    @line_api_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_MESSAGING_API_CHANNEL_SECRET']
      config.channel_token  = ENV['LINE_MESSAGING_API_CHANNEL_TOKEN']
    end
  end

  # TODO: i18n で何とかなるのでは……
  def boolean_english_to_japanese(boolean_object)
    if boolean_object.is_a?(TrueClass)
      'はい'
    else
      'いいえ'
    end
  end

  # TODO: 絶対に gem がありそう
  # https://morizyun.github.io/ruby/tips-image-type-check-png-jpeg-gif.html
  def image_format_type(filepath)
    File.open(filepath, 'rb') do |f|
      begin
        header = f.read(8)
        f.seek(-12, IO::SEEK_END)
        footer = f.read(12)
      rescue
        return nil
      end

      if header[0, 2].unpack('H*') == %w(ffd8) && footer[-2, 2].unpack('H*') == %w(ffd9)
        return 'jpg'
      elsif header[0, 3].unpack('A*') == %w(GIF) && footer[-1, 1].unpack('H*') == %w(3b)
        return 'gif'
      elsif header[0, 8].unpack('H*') == %w(89504e470d0a1a0a) && footer[-12,12].unpack('H*') == %w(0000000049454e44ae426082)
        return 'png'
      end
    end

    nil
  end
end
