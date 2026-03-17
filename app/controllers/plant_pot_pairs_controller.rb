class PlantPotPairsController < ApplicationController
  def create
    plant = Plant.find(params[:plant_id])
    pot = Pot.find(params[:pot_id])

    if pot.leaf_coin_value <= current_user.leaf_coins
      bought = PlantPotPair.new(plant: plant, pot: pot, equipped: false)
      if bought.save
        current_user.update(leaf_coins: current_user.leaf_coins - pot.leaf_coin_value)
        redirect_to plant_pots_path(plant), notice: "New pot color unlocked for #{plant.nickname}!"
      else
        flash[:alert] = "Could not save new pot for this plant..."
        redirect_to plant_pots_path(plant)
      end
    else
      flash[:alert] = "You don't have enough coins :("
      redirect_to plant_pots_path(plant)
    end
  end

  def update
    plant = Plant.find(params[:plant_id])
    pot = Pot.find(params[:pot_id])
    currently_equipped = PlantPotPair.find_by(plant: plant, equipped: true)
    selected = PlantPotPair.find_by(plant: plant, pot: pot)

    unless selected == currently_equipped
      selected.update(equipped: true)
      currently_equipped&.update(equipped: false)
      plant.avatar_updating!
    end
    redirect_to plant_pots_path(plant)
  end

  def destroy
  end
end
