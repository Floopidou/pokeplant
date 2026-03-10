# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_10_115726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "plant_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["plant_id"], name: "index_chats_on_plant_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "plant_pot_pairs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "equipped"
    t.bigint "plant_id", null: false
    t.bigint "pot_id", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_plant_pot_pairs_on_plant_id"
    t.index ["pot_id"], name: "index_plant_pot_pairs_on_pot_id"
  end

  create_table "plants", force: :cascade do |t|
    t.string "avatar_img"
    t.string "common_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "ideal_pot_size"
    t.date "input_date"
    t.date "last_repot"
    t.date "last_watered"
    t.integer "light_need"
    t.integer "mood_points"
    t.string "nickname"
    t.string "optimal_placement"
    t.string "origin_region"
    t.string "personality"
    t.string "personality_tags"
    t.string "photo_url"
    t.string "plant_size"
    t.integer "position_in_garden"
    t.integer "repot_interval"
    t.string "scientific_name"
    t.float "temperature_max"
    t.float "temperature_min"
    t.integer "toxicity"
    t.string "type_of_soil"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "watering_interval"
    t.index ["user_id"], name: "index_plants_on_user_id"
  end

  create_table "pots", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.integer "leaf_coin_value"
    t.string "pot_img"
    t.string "pot_size"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "leaf_coins"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "plants"
  add_foreign_key "chats", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "plant_pot_pairs", "plants"
  add_foreign_key "plant_pot_pairs", "pots"
  add_foreign_key "plants", "users"
end
