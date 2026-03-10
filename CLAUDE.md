# PokéPlant — CLAUDE.md

## Project Overview

PokéPlant is a Rails 8 web app where users manage plants with a Pokémon-like personality system. Plants have personalities, mood points, care schedules, and users can chat with their plants. Includes a collectible pot system with in-game currency (leaf coins).

## Tech Stack

- **Ruby** 3.3.5 / **Rails** 8.1.2
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus), Bootstrap 5.3, Importmap, SCSS
- **Auth**: Devise
- **Forms**: Simple Form
- **Testing**: Minitest (parallel)
- **Assets**: Active Storage + image_processing

## Common Commands

```bash
bin/setup          # Install deps + prepare DB
bin/dev            # Start dev server (port 3000)
bin/rails test     # Run all tests
bin/rails db:migrate
bin/rails db:seed
```

## Project Structure

```
app/models/         # User, Plant, Chat, Message, Pot, PlantPotPair
app/controllers/    # PagesController, PlantsController, ChatsController,
                    # MessagesController, PotsController, PlantPotPairsController
app/views/          # ERB templates (plants/, chats/, pots/, pages/, shared/)
test/models/        # Comprehensive Minitest model tests
test/controllers/   # Controller tests for all resources
db/migrate/         # 8 migrations
config/routes.rb    # Full RESTful routes (see Routes section below)
```

## Domain Models

| Model | Key fields | Associations |
|-------|-----------|--------------|
| User | email, username, birthdate, leaf_coins (default 0) | has_many :plants, :chats |
| Plant | nickname, common_name, scientific_name, mood_points (0-100), personality (15 types), personality_tags, plant_size, ideal_pot_size, light_need (0-10), toxicity (0-10), temperature_min/max, type_of_soil, optimal_placement, origin_region, description, watering_interval, repot_interval, last_watered, last_repot, input_date, avatar_img, position_in_garden | belongs_to :user, has_many :plantpotpairs, :chats |
| Chat | — | belongs_to :plant, :user; has_many :messages |
| Message | content (text), role (string) | belongs_to :chat |
| Pot | color, pot_size, pot_img, leaf_coin_value | has_many :plantpotpairs |
| PlantPotPair | equipped (boolean) | belongs_to :plant, :pot |

## Plant Personalities (15 types)
bucolic, partygoer, rustic, vacationer, assistant, guide, inspector, rescuer, choosy, diva, gentle, majesty, artist, clumsy, pilferer, troublemaker

## Plant/Pot Sizes (enum)
small, medium, large, very_large, tree

## Key Validations
- mood_points: 0–100
- light_need, toxicity: 0–10
- temperature_min/max: -20 to 100
- last_watered, last_repot: must be ≤ today
- personality: must be one of 15 predefined values
- ideal_pot_size, plant_size: must be in size enum
- All Plant fields required (presence): nickname, common_name, scientific_name, avatar_img, position_in_garden, personality, personality_tags, plant_size, ideal_pot_size, light_need, toxicity, temperature_min, temperature_max, type_of_soil, optimal_placement, origin_region, description, watering_interval, repot_interval, last_watered, last_repot, input_date

## Language
All UI text, labels, buttons, flash messages, and any user-facing content must be in **English** by default.

## Routes

```
GET    /                          pages#home
GET    /loading                   pages#loading
GET    /all_reminders             pages#reminders

resources :plants (full CRUD)
  GET    /plants/:id/plant_reminders
  PATCH  /plants/:id/update_name
  PATCH  /plants/:id/water
  PATCH  /plants/:id/repot
  PATCH  /plants/:id/pet

  resources :chats (create, index, show, destroy)
    resources :messages (create only)

resources :pots (index, show)
  resources :plant_pot_pairs (create only)   # buying a pot

resources :plant_pot_pairs (destroy only)    # unequipping/removing a pot
```

> **Pitfall**: do NOT add top-level `get "chats/show"` style routes — they shadow the nested resource routes.

## Current Status
Models + tests complete. Controllers, views, and routes for plants, chats, pots, messages, and plant_pot_pairs are built.

## Linting & CI
- RuboCop: `rubocop-rails-omakase` style (see `.rubocop.yml`)
- Brakeman for security scanning
- CI: `.github/workflows/ci.yml`
