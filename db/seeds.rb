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

habib = User.create!(
  email: "habib@example.com",
  password: "000000",
  username: "habib",
  birthdate: Date.new(1995, 6, 15),
  leaf_coins: 869
)

chloe = User.create!(
  email: "chloe@example.com",
  password: "000000",
  username: "chloe",
  birthdate: Date.new(1995, 6, 15),
  leaf_coins: 2000
)

mickael = User.create!(
  email: "mickael@example.com",
  password: "000000",
  username: "mickael",
  birthdate: Date.new(1995, 6, 15),
  leaf_coins: 100
)

perrine = User.create!(
  email: "perrine@example.com",
  password: "000000",
  username: "perrine",
  birthdate: Date.new(1996, 9, 26),
  leaf_coins: 1000
)

# --- Pots ---
puts "Creating pots..."

Pot.create!(
  color: "green",
  pot_size: "medium",
  pot_img: "green_pot.png",
  leaf_coin_value: 20
)

pot_basique = Pot.create!(
  color: "pink",
  pot_size: "medium",
  pot_img: "pink_pot.png",
  leaf_coin_value: 0
)

Pot.create!(
  color: "blue",
  pot_size: "medium",
  pot_img: "blue_pot.png",
  leaf_coin_value: 20
)

Pot.create!(
  color: "purple",
  pot_size: "medium",
  pot_img: "purple_pot.png",
  leaf_coin_value: 100
)

Pot.create!(
  color: "red",
  pot_size: "medium",
  pot_img: "red_pot.png",
  leaf_coin_value: 80
)

Pot.create!(
  color: "yellow",
  pot_size: "medium",
  pot_img: "yellow_pot.png",
  leaf_coin_value: 40
)

# --- Plants ---
puts "Creating plants..."

monstera_manon = Plant.create!(
  user: manon,
  nickname: "Monsti",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.png",
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
  mood_points: 20,
  last_watered: Date.new(2026, 3, 14),
  last_repot: Date.new(2024, 6, 5),
  last_petting: Date.new(2026, 3, 13)
)

golden_pothos = Plant.create!(
  user: manon,
  nickname: "Goldie",
  common_name: "Golden Pothos",
  scientific_name: "Epipremnum aureum",
  avatar_img: "pothos_pink_happy.png",
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
  watering_interval: 4,
  repot_interval: 548,
  mood_points: 75,
  last_watered: Date.new(2026, 3, 12),
  last_petting: Date.new(2026, 3, 13)
)

ficus = Plant.create!(
  user: manon,
  nickname: "Fifi",
  common_name: "Ficus lyrata",
  scientific_name: "Ficus lyrata",
  avatar_img: "undefined_pink_happy.png",
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
  mood_points: 70,
  last_watered: Date.new(2026, 3, 12),
  last_repot: Date.new(2026, 1, 12),
  last_petting: Date.new(2026, 3, 13)
)

monstera_bob = Plant.create!(
  user: bob,
  nickname: "Monstro",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.png",
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
  mood_points: 95,
  last_watered: Date.new(2026, 3, 15),
  last_repot: Date.new(2025, 2, 12),
  last_petting: Date.new(2026, 3, 15)
)


# habib
habib_1 = Plant.create!(
  user: habib,
  nickname: "Choubidou",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.png",
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
  mood_points: 20,
  last_watered: Date.new(2026, 3, 14),
  last_repot: Date.new(2024, 6, 5),
  last_petting: Date.new(2026, 3, 13)
)

habib_2 = Plant.create!(
  user: habib,
  nickname: "Bob",
  common_name: "Golden Pothos",
  scientific_name: "Epipremnum aureum",
  avatar_img: "pothos_pink_happy.png",
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
  watering_interval: 4,
  repot_interval: 548,
  mood_points: 75,
  last_watered: Date.new(2026, 3, 12),
  last_petting: Date.new(2026, 3, 13)
)

habib_3 = Plant.create!(
  user: habib,
  nickname: "JasonMraz",
  common_name: "Ficus lyrata",
  scientific_name: "Ficus lyrata",
  avatar_img: "undefined_pink_happy.png",
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
  mood_points: 70,
  last_watered: Date.new(2026, 3, 12),
  last_repot: Date.new(2026, 1, 12),
  last_petting: Date.new(2026, 3, 13)
)

habib_4 = Plant.create!(
  user: habib,
  nickname: "Spiky",
  common_name: "Cactus",
  scientific_name: "Echinopsis pachanoi",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 4,
  personality: "rustic",
  personality_tags: "tough,independent,resilient",
  plant_size: "medium",
  ideal_pot_size: "small",
  light_need: 9,
  toxicity: 2,
  temperature_min: 5,
  temperature_max: 40,
  type_of_soil: "cactus and succulent mix with sand",
  optimal_placement: "south-facing windowsill with maximum sun",
  origin_region: "South America (Andes)",
  description: "Columnar cactus that thrives on neglect. Barely needs watering.",
  watering_interval: 21,
  repot_interval: 1095,
  mood_points: 85,
  last_watered: Date.new(2026, 2, 25),
  last_repot: Date.new(2025, 6, 1),
  last_petting: Date.new(2026, 3, 10)
)

habib_5 = Plant.create!(
  user: habib,
  nickname: "Velvet",
  common_name: "African Violet",
  scientific_name: "Saintpaulia ionantha",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 5,
  personality: "gentle",
  personality_tags: "soft,delicate,cheerful",
  plant_size: "small",
  ideal_pot_size: "small",
  light_need: 5,
  toxicity: 1,
  temperature_min: 15,
  temperature_max: 26,
  type_of_soil: "light African violet mix",
  optimal_placement: "east-facing windowsill, no direct afternoon sun",
  origin_region: "East Africa (Tanzania)",
  description: "Compact flowering plant with fuzzy leaves and vibrant purple blooms.",
  watering_interval: 5,
  repot_interval: 365,
  mood_points: 60,
  last_watered: Date.new(2026, 3, 15),
  last_repot: Date.new(2025, 10, 5),
  last_petting: Date.new(2026, 3, 16)
)

habib_6 = Plant.create!(
  user: habib,
  nickname: "Dracula",
  common_name: "ZZ Plant",
  scientific_name: "Zamioculcas zamiifolia",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 6,
  personality: "inspector",
  personality_tags: "watchful,stoic,enduring",
  plant_size: "medium",
  ideal_pot_size: "medium",
  light_need: 3,
  toxicity: 7,
  temperature_min: 10,
  temperature_max: 35,
  type_of_soil: "well-draining potting mix",
  optimal_placement: "any room, tolerates low light corners",
  origin_region: "Eastern Africa",
  description: "Nearly indestructible glossy plant. Stores water in rhizomes, tolerates neglect perfectly.",
  watering_interval: 14,
  repot_interval: 730,
  mood_points: 78,
  last_watered: Date.new(2026, 3, 5),
  last_repot: Date.new(2025, 9, 20),
  last_petting: Date.new(2026, 3, 11)
)

habib_7 = Plant.create!(
  user: habib,
  nickname: "Bambino",
  common_name: "Lucky Bamboo",
  scientific_name: "Dracaena sanderiana",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 7,
  personality: "bucolic",
  personality_tags: "peaceful,zen,harmonious",
  plant_size: "small",
  ideal_pot_size: "small",
  light_need: 4,
  toxicity: 3,
  temperature_min: 15,
  temperature_max: 30,
  type_of_soil: "grows in water or light well-draining soil",
  optimal_placement: "indirect light on a desk or shelf",
  origin_region: "Central Africa",
  description: "Elegant stalks often grown in water. Symbolizes good fortune and positive energy.",
  watering_interval: 7,
  repot_interval: 548,
  mood_points: 92,
  last_watered: Date.new(2026, 3, 14),
  last_repot: Date.new(2025, 12, 1),
  last_petting: Date.new(2026, 3, 17)
)

habib_8 = Plant.create!(
  user: habib,
  nickname: "Flamingo",
  common_name: "Anthurium",
  scientific_name: "Anthurium andraeanum",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 8,
  personality: "partygoer",
  personality_tags: "vibrant,social,flamboyant",
  plant_size: "small",
  ideal_pot_size: "small",
  light_need: 6,
  toxicity: 6,
  temperature_min: 16,
  temperature_max: 28,
  type_of_soil: "orchid mix or coarse well-draining soil",
  optimal_placement: "bright indirect light, humid bathroom or kitchen",
  origin_region: "Colombia and Ecuador",
  description: "Tropical plant with striking waxy red spathes. Loves humidity and warmth.",
  watering_interval: 7,
  repot_interval: 548,
  mood_points: 55,
  last_watered: Date.new(2026, 3, 11),
  last_repot: Date.new(2025, 8, 15),
  last_petting: Date.new(2026, 3, 14)
)

# chloe
chloe_1 = Plant.create!(
  user: chloe,
  nickname: "Tropicana",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.png",
  position_in_garden: 1,
  personality: "diva",
  personality_tags: "glamorous,demanding,lush",
  plant_size: "large",
  ideal_pot_size: "large",
  light_need: 7,
  toxicity: 5,
  temperature_min: 15,
  temperature_max: 30,
  type_of_soil: "well-draining universal potting mix",
  optimal_placement: "near a bright window, away from direct sunlight",
  origin_region: "Central and South America",
  description: "Tropical plant with large split leaves, perfect for brightening up any interior.",
  watering_interval: 7,
  repot_interval: 365,
  mood_points: 20,
  last_watered: Date.new(2026, 3, 14),
  last_repot: Date.new(2024, 6, 5),
  last_petting: Date.new(2026, 3, 13)
)

chloe_2 = Plant.create!(
  user: chloe,
  nickname: "Noodle",
  common_name: "Golden Pothos",
  scientific_name: "Epipremnum aureum",
  avatar_img: "pothos_pink_happy.png",
  position_in_garden: 2,
  personality: "partygoer",
  personality_tags: "easygoing,trailing,sociable",
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
  watering_interval: 4,
  repot_interval: 548,
  mood_points: 75,
  last_watered: Date.new(2026, 3, 12),
  last_petting: Date.new(2026, 3, 13)
)

chloe_3 = Plant.create!(
  user: chloe,
  nickname: "Cactucci",
  common_name: "Golden Barrel Cactus",
  scientific_name: "Echinocactus grusonii",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 3,
  personality: "choosy",
  personality_tags: "prickly,independent,stubborn",
  plant_size: "small",
  ideal_pot_size: "small",
  light_need: 9,
  toxicity: 2,
  temperature_min: 5,
  temperature_max: 40,
  type_of_soil: "cactus and succulent mix",
  optimal_placement: "sunny windowsill with direct light",
  origin_region: "Mexico",
  description: "A classic golden barrel cactus that thrives on neglect and full sun.",
  watering_interval: 21,
  repot_interval: 730,
  mood_points: 70,
  last_watered: Date.new(2026, 3, 12),
  last_repot: Date.new(2026, 1, 12),
  last_petting: Date.new(2026, 3, 13)
)

# mickael
mickael_1 = Plant.create!(
  user: mickael,
  nickname: "BigLeaf",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.png",
  position_in_garden: 1,
  personality: "rustic",
  personality_tags: "sturdy,reliable,grounded",
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
  mood_points: 20,
  last_watered: Date.new(2026, 3, 14),
  last_repot: Date.new(2024, 6, 5),
  last_petting: Date.new(2026, 3, 13)
)

mickael_2 = Plant.create!(
  user: mickael,
  nickname: "Viny",
  common_name: "Golden Pothos",
  scientific_name: "Epipremnum aureum",
  avatar_img: "pothos_pink_happy.png",
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
  watering_interval: 4,
  repot_interval: 548,
  mood_points: 75,
  last_watered: Date.new(2026, 3, 12),
  last_petting: Date.new(2026, 3, 13)
)

mickael_3 = Plant.create!(
  user: mickael,
  nickname: "Zeb",
  common_name: "Zebra Plant",
  scientific_name: "Aphelandra squarrosa",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 3,
  personality: "artist",
  personality_tags: "dramatic,striped,expressive",
  plant_size: "small",
  ideal_pot_size: "small",
  light_need: 6,
  toxicity: 1,
  temperature_min: 15,
  temperature_max: 27,
  type_of_soil: "peat-based potting mix",
  optimal_placement: "bright indirect light, away from cold drafts",
  origin_region: "Brazil",
  description: "Striking foliage with bold white veins. Rewards attentive care with vivid yellow flowers.",
  watering_interval: 5,
  repot_interval: 365,
  mood_points: 70,
  last_watered: Date.new(2026, 3, 12),
  last_repot: Date.new(2026, 1, 12),
  last_petting: Date.new(2026, 3, 13)
)

# perrine
perrine_1 = Plant.create!(
  user: perrine,
  nickname: "Fenêtre",
  common_name: "Monstera",
  scientific_name: "Monstera deliciosa",
  avatar_img: "monstera_pink_happy.png",
  position_in_garden: 1,
  personality: "guide",
  personality_tags: "wise,calm,nurturing",
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
  mood_points: 20,
  last_watered: Date.new(2026, 3, 14),
  last_repot: Date.new(2024, 6, 5),
  last_petting: Date.new(2026, 3, 13)
)

perrine_2 = Plant.create!(
  user: perrine,
  nickname: "Cascade",
  common_name: "Golden Pothos",
  scientific_name: "Epipremnum aureum",
  avatar_img: "pothos_pink_happy.png",
  position_in_garden: 2,
  personality: "bucolic",
  personality_tags: "peaceful,lush,flowing",
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
  watering_interval: 4,
  repot_interval: 548,
  mood_points: 75,
  last_watered: Date.new(2026, 3, 12),
  last_petting: Date.new(2026, 3, 13)
)

perrine_3 = Plant.create!(
  user: perrine,
  nickname: "Rosalinde",
  common_name: "Peace Lily",
  scientific_name: "Spathiphyllum wallisii",
  avatar_img: "undefined_pink_happy.png",
  position_in_garden: 3,
  personality: "gentle",
  personality_tags: "elegant,delicate,serene",
  plant_size: "medium",
  ideal_pot_size: "medium",
  light_need: 4,
  toxicity: 6,
  temperature_min: 15,
  temperature_max: 30,
  type_of_soil: "rich well-draining potting mix",
  optimal_placement: "low to bright indirect light, away from cold drafts",
  origin_region: "Tropical Americas",
  description: "Elegant white-blooming plant that thrives in shade and signals thirst by drooping its leaves.",
  watering_interval: 5,
  repot_interval: 548,
  mood_points: 70,
  last_watered: Date.new(2026, 3, 12),
  last_repot: Date.new(2026, 1, 12),
  last_petting: Date.new(2026, 3, 13)
)

# --- PlantPotPairs (chaque plante associée au pot basique) ---
puts "Creating plant-pot pairs..."

[monstera_manon, golden_pothos, ficus, monstera_bob, habib_1, habib_2, habib_3,
 habib_4, habib_5, habib_6, habib_7, habib_8,
 chloe_1, chloe_2, chloe_3, mickael_1, mickael_2, mickael_3,
 perrine_1, perrine_2, perrine_3].each do |plant|
  PlantPotPair.create!(plant: plant, pot: pot_basique, equipped: true)
end

# --- Chat de bob avec sa monstera ---
puts "Creating chat and messages..."

chat = Chat.create!(user: bob, plant: monstera_bob)

Message.create!(chat: chat, role: "user", content: "Salut Monstro, comment tu vas aujourd'hui ?")
Message.create!(chat: chat, role: "assistant", content: "Je me sens plein d'énergie ! Mes feuilles brillent et j'ai soif d'aventure. Tu penses à m'arroser bientôt ?")

puts "Seed done! #{User.count} users, #{Plant.count} plants, #{Pot.count} pots, #{Chat.count} chat, #{Message.count} messages."
