# class ChatsController < ApplicationController
#   before_action :authenticate_user! # Si tu utilises Devise

#   def show
#     @plant = current_user.plants.find(params[:id]) if params[:id].present?
#     # Ou simplement pour tester :
#     # @plant = nil
#   end

#   def test
#     # Rien à charger, juste afficher la vue
#   end
# end
class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plant

  def index
    @chats = @plant.chats.order(created_at: :desc)
  end

  def show
    @chat = @plant.chats.find(params[:id])
    @messages = @chat.messages.order(:created_at)
    @message = Message.new
  end

  def create
    @chat = @plant.chats.create!(user: current_user)
    redirect_to plant_chat_path(@plant, @chat)
  end

  def destroy
    @chat = @plant.chats.find(params[:id])
    @chat.destroy
    redirect_to plant_chats_path(@plant), notice: "Conversation supprimée"
  end

  def test
    # Page de test statique
  end

  private

  def set_plant
    @plant = current_user.plants.find(params[:plant_id]) if params[:plant_id]
  end
end
