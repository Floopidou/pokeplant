class PlantPotPair < ApplicationRecord
  belongs_to :pot
  belongs_to :plant

  validates :plant, :pot, :equipped, presence: true
end
