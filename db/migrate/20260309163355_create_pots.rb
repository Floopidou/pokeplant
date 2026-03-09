class CreatePots < ActiveRecord::Migration[8.1]
  def change
    create_table :pots do |t|
      t.string :pot_size
      t.string :color
      t.string :pot_img
      t.integer :leaf_coin_value

      t.timestamps
    end
  end
end
