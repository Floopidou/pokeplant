class RemovePhotoUrlFromPlants < ActiveRecord::Migration[8.1]
  def change
    remove_column :plants, :photo_url, :string
  end
end
