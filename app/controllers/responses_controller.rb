class ResponsesController < ApplicationController
  def index
    @records = ReactionWord.all

    # TODO: Fat Controller の典型
    case
    when request.post?
      posted_user_message  = params[:user_message]
      posted_reply_message = params[:reply_message]

      begin
        created_record = ReactionWord.create!(
          user_message: posted_user_message,
          reply_message: posted_reply_message,
        )
        @message = "No.#{created_record.id} に「#{posted_user_message}」→「#{posted_reply_message}」のデータを追加しました！"
      rescue
        @message = 'すでに登録されています！登録を中止しました！'
      end

    when request.delete?
      target_id = params[:delete_id]

      if ReactionWord.find_by(id: target_id)
        ReactionWord.destroy(target_id)
        @message = "No.#{target_id} のデータを削除しました！"
      else
        @message = '削除対象のデータが存在しません！'
      end
    end
  end
end
