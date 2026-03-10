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
app/controllers/    # Minimal — mostly Devise + PagesController
app/views/          # ERB templates
test/models/        # Comprehensive Minitest model tests
db/migrate/         # 8 migrations
config/routes.rb    # Currently: root + devise_for only
```

## Domain Models

| Model | Key fields | Associations |
|-------|-----------|--------------|
| User | email, username, birthdate, leaf_coins (default 0) | has_many :plants, :chats |
| Plant | nickname, common_name, mood_points (0-100), personality (15 types), plant_size, light_need (0-10), toxicity (0-10), temperature_min/max, last_watered, last_repot | belongs_to :user, has_many :plantpotpairs, :chats |
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

## Current Status
Models + tests complete. Routes/controllers/views for plants, chats, pots not yet built.

## Linting & CI
- RuboCop: `rubocop-rails-omakase` style (see `.rubocop.yml`)
- Brakeman for security scanning
- CI: `.github/workflows/ci.yml`
