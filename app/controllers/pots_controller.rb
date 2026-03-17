class PotsController < ApplicationController
  def index
    @pots = Pot.order(:leaf_coin_value)
    @plant = Plant.find(params[:plant_id])
    @owned_pairs = @plant.plant_pot_pairs.index_by(&:pot_id)
  end
end
