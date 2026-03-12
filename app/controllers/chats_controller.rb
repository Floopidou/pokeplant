class ChatsController < ApplicationController
  before_action :authenticate_user! # Si tu utilises Devise

  def show
    @plant = current_user.plants.find(params[:id]) if params[:id].present?
    # Ou simplement pour tester :
    # @plant = nil
  end

  def test
    # Rien à charger, juste afficher la vue
  end
end
