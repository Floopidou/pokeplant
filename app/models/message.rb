class Message < ApplicationRecord
  belongs_to :chat

  has_one_attached :image

  validates :chat, presence: true
  validates :content, presence: true, unless: :image_attached?
  validates :role, presence: true

  private

  def image_attached?
    image.attached?
  end
end
