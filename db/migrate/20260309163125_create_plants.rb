class CreatePlants < ActiveRecord::Migration[8.1]
  def change
    create_table :plants do |t|
      t.integer :position_in_garden
      t.string :avatar_img
      t.string :nickname
      t.string :common_name
      t.integer :mood_points
      t.integer :watering_interval
      t.integer :repot_interval
      t.date :last_watered
      t.date :last_repot
      t.float :temperature_min
      t.float :temperature_max
      t.integer :light_need
      t.integer :toxicity
      t.string :type_of_soil
      t.string :ideal_pot_size
      t.string :optimal_placement
      t.string :plant_size
      t.text :description
      t.string :origin_region
      t.string :scientific_name
      t.string :personality
      t.date :input_date
      t.string :personality_tags
      t.string :photo_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
