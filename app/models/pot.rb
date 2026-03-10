class Pot < ApplicationRecord
  has_many :plantpotpairs

  validates :pot_size, :color, :pot_img, :leaf_coin_value, presence: true
  validates :pot_size, inclusion: { in: %w[small medium large very_large tree] }
end
