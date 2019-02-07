class ReactionWord < ApplicationRecord
  validates :user_message, presence: true, uniqueness: true

  scope :reply_records, ->(message) { where(user_message: message) }

  def self.reply_record(event_message)
    ReactionWord.reply_records(event_message).first || nil
  end
end
