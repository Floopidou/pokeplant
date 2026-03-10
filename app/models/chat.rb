class Chat < ApplicationRecord
  belongs_to :plant
  belongs_to :user
  has_many :messages

  validates :user, :plant, presence: true
end
