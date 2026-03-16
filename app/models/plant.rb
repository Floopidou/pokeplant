class Plant < ApplicationRecord
  # valeurs par défaut
  before_validation do
    self.mood_points ||= 100 # assigne 100 SSI les mood_points en sont pas preset
    self.input_date ||= Date.today
    self.last_repot ||= Date.today
    self.last_watered ||= Date.today
  end

  belongs_to :user
  has_many :plant_pot_pairs, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_one_attached :photo

  # presence de tout sauf photo, nickanme (défini après) personality et personality tags (défini après)
  validates :user, :avatar_img, :position_in_garden, :common_name, :scientific_name,
            :watering_interval, :repot_interval, :mood_points, :light_need, :toxicity,
            :temperature_min, :temperature_max, :type_of_soil,
            :ideal_pot_size, :plant_size,
            :last_repot, :last_watered, :input_date,
            :description, :optimal_placement, :origin_region,
            presence: true

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
                                troublemaker] },
            allow_nil: true
  # dates last_repot, last_watered, input_date <=today
  validates :last_repot, :last_watered, comparison: { less_than_or_equal_to: ->(_) { Date.today } }

  def mood
    return "thirsty" if needs_water?
    return "grumpy" if needs_repot?
    return "lonely" if mood_points <= 60

    "happy"
  end

  # getting the right avatar for the plant at creation
  def avatar_setting!
    self.avatar_img = "#{plant_type}_pink_#{mood}.svg"
  end

  # updating the avatar
  def avatar_updating!
    self.avatar_img = "#{plant_type}_#{pot_color}_#{mood}.svg"
  end

  def plant_type
    if common_name.downcase.include?("swiss") || common_name.downcase.include?("monstera")
      return "monstera"
    elsif common_name.downcase.include?("pothos")
      return "pothos"
    else
      return "undefined"
    end
  end
  
  private

  def needs_water?
    (Date.today - self.last_watered).to_i >= watering_interval
  end

  def needs_repot?
    (Date.today - self.last_repot).to_i >= repot_interval
  end

  ### avatars infos
  def pot_color
    return "pink" # todo
  end


end
