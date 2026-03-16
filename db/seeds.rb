# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Cleaning database..."
PlantPotPair.destroy_all
Message.destroy_all
Chat.destroy_all
Plant.destroy_all
Pot.destroy_all
User.destroy_all

# --- Users ---
puts "Creating users..."

manon = User.create!(
  email: "manon@example.com",
  password: "password123",
  username: "manon",
  birthdate: Date.new(1995, 6, 15),
  leaf_coins: 100
)

bob = User.create!(
  email: "bob@example.com",
  password: "password123",
  username: "bob",
  birthdate: Date.new(1990, 3, 22),
  leaf_coins: 50
)

# --- Pots ---
puts "Creating pots..."

pot_basique = Pot.create!(
  color: "terracotta",
  pot_size: "medium",
  pot_img: "pot_basique.png",
  leaf_coin_value: 0
)

Pot.create!(
  color: "white",
  pot_size: "large",
  pot_img: "pot_blanc.png",
  leaf_coin_value: 20
)

Pot.create!(
  color: "black",
  pot_size: "small",
  pot_img: "pot_noir.png",
  leaf_coin_value: 30
)

Pot.create!(
  color: "gold",
  pot_size: "very_large",
  pot_img: "pot_dore.png",
  leaf_coin_value: 100
)

# --- Plants ---
puts "Creating plants..."

monstera_manon = Plant.create!(
  user: manon,
  nickname: "Monsti",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.svg",
  position_in_garden: 1,
  personality: "gentle",
  personality_tags: "calm,caring,bright",
  plant_size: "large",
  ideal_pot_size: "large",
  light_need: 6,
  toxicity: 5,
  temperature_min: 15,
  temperature_max: 30,
  type_of_soil: "well-draining universal potting mix",
  optimal_placement: "near a bright window, away from direct sunlight",
  origin_region: "Central and South America",
  description: "Tropical plant with large split leaves, perfect for brightening up any interior.",
  watering_interval: 7,
  repot_interval: 365,
  mood_points: 90
)

golden_pothos = Plant.create!(
  user: manon,
  nickname: "Goldie",
  common_name: "Golden Pothos",
  scientific_name: "Epipremnum aureum",
  avatar_img: "pothos_pink_happy.svg",
  position_in_garden: 2,
  personality: "clumsy",
  personality_tags: "easygoing,trailing,resilient",
  plant_size: "medium",
  ideal_pot_size: "medium",
  light_need: 3,
  toxicity: 4,
  temperature_min: 15,
  temperature_max: 30,
  type_of_soil: "well-draining potting mix",
  optimal_placement: "bright indirect light, tolerates low light",
  origin_region: "Southeast Asia",
  description: "One of the easiest houseplants to grow, with heart-shaped golden-green leaves. Nearly impossible to kill.",
  watering_interval: 7,
  repot_interval: 548,
  mood_points: 75
)

ficus = Plant.create!(
  user: manon,
  nickname: "Fifi",
  common_name: "Ficus lyrata",
  scientific_name: "Ficus lyrata",
  avatar_img: "undefined_pink_happy.svg",
  position_in_garden: 3,
  personality: "majesty",
  personality_tags: "majestic,imposing,steady",
  plant_size: "very_large",
  ideal_pot_size: "large",
  light_need: 8,
  toxicity: 4,
  temperature_min: 15,
  temperature_max: 32,
  type_of_soil: "draining mix with a little sand",
  optimal_placement: "bright stable spot, away from radiators",
  origin_region: "Tropical West Africa",
  description: "Indoor tree with large violin-shaped leaves. Does not like to be moved.",
  watering_interval: 10,
  repot_interval: 730,
  mood_points: 85
)

monstera_bob = Plant.create!(
  user: bob,
  nickname: "Monstro",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.svg",
  position_in_garden: 1,
  personality: "partygoer",
  personality_tags: "lively,energetic,sociable",
  plant_size: "large",
  ideal_pot_size: "large",
  light_need: 6,
  toxicity: 5,
  temperature_min: 15,
  temperature_max: 30,
  type_of_soil: "well-draining universal potting mix",
  optimal_placement: "near a bright window, away from direct sunlight",
  origin_region: "Central and South America",
  description: "A lively Monstera that loves attention and thrives with regular care.",
  watering_interval: 7,
  repot_interval: 365,
  mood_points: 95
)

# --- PlantPotPairs (chaque plante associée au pot basique) ---
puts "Creating plant-pot pairs..."

[monstera_manon, golden_pothos, ficus, monstera_bob].each do |plant|
  PlantPotPair.create!(plant: plant, pot: pot_basique, equipped: true)
end

# --- Chat de bob avec sa monstera ---
puts "Creating chat and messages..."

chat = Chat.create!(user: bob, plant: monstera_bob)

Message.create!(chat: chat, role: "user", content: "Salut Monstro, comment tu vas aujourd'hui ?")
Message.create!(chat: chat, role: "assistant", content: "Je me sens plein d'énergie ! Mes feuilles brillent et j'ai soif d'aventure. Tu penses à m'arroser bientôt ?")

puts "Seed done! #{User.count} users, #{Plant.count} plants, #{Pot.count} pots, #{Chat.count} chat, #{Message.count} messages."
