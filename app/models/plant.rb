class Plant < ApplicationRecord
  # valeurs par défaut
  before_validation do
    self.mood_points ||= 100 # assigne 100 SSI les mood_points en sont pas preset
    self.input_date ||= Date.today
    self.last_repot ||= Date.today
    self.last_watered ||= Date.today
  end

  belongs_to :user
  has_many :plantpotpairs
  has_many :chats

  # presence de tout sauf photo url pour l'instant
  validates :user, :avatar_img, :position_in_garden, :nickname, :common_name, :mood_points,
            :light_need, :toxicity, :temperature_min, :temperature_max, :ideal_pot_size,
            :plant_size, :personality, :last_repot, :last_watered, :input_date, presence: true

  # moodpoints entre 0 et 100
  validates :mood_points, inclusion: { in: 0..100 }
  # light need et toxicity entre 0 et 10
  validates :light_need, :toxicity, inclusion: { in: 0..10 }
  # min temperature aet max temperation entre -20 et 100
  validates :temperature_min, :temperature_max, inclusion: { in: -20..100 }
  # ideal pot size categories Small / Medium / Large / Very Large / Tree-sized
  # # plant_size Small / Medium / Large / Very Large / Tree-sized
  validates :ideal_pot_size, :plant_size, inclusion: { in: %w[small medium large very_large tree] }

  # personality Bucolic / PartyGoer / Rustic / Vacationer / Assistant / Guide / Inspector /
  # Rescuer / Choosy / Diva / Gentle / Majesty / Artist / clumsy / Pilferer / Troublemaker
  validates :personality,
            inclusion: { in: %w[bucolic partygoer rustic vacationer assistant guide inspector
                                rescuer choosy diva gentle majesty artist clumsy pilferer
                                troublemaker] }
  # dates last_repot, last_watered, input_date <=today
  validates :last_repot, :last_watered, comparison: { less_than_or_equal_to: ->(_) { Date.today } }
end
