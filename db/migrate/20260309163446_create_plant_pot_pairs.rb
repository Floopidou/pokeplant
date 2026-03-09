class CreatePlantPotPairs < ActiveRecord::Migration[8.1]
  def change
    create_table :plant_pot_pairs do |t|
      t.references :pot, null: false, foreign_key: true
      t.references :plant, null: false, foreign_key: true
      t.boolean :equipped

      t.timestamps
    end
  end
end
