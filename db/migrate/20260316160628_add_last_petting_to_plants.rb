class AddLastPettingToPlants < ActiveRecord::Migration[8.1]
  def change
    add_column :plants, :last_petting, :date
  end
end
