class PlantPotPair < ApplicationRecord
  belongs_to :pot
  belongs_to :plant

  validates :plant, :pot, presence: true
  validates :equipped, inclusion: { in: [true, false] }
end
