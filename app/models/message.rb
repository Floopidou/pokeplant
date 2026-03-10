class Message < ApplicationRecord
  belongs_to :chat

  validates :role, :content, :chat, presence: true
end
