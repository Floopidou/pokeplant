class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plant
  skip_before_action :load_reminders

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

    # Générer le message de bienvenue de la plante
    welcome_message = generate_welcome_message
    @chat.messages.create!(role: "assistant", content: welcome_message)

    redirect_to plant_chat_path(@plant, @chat)
  end

  def destroy
    @chat = @plant.chats.find(params[:id])
    @chat.destroy
    redirect_to plant_chats_path(@plant), notice: "Conversation deleted"
  end

  private

  def set_plant
    @plant = current_user.plants.find(params[:plant_id]) if params[:plant_id]
  end

  def generate_welcome_message
    RubyLLM
      .chat(model: "gpt-4o-mini")
      .with_instructions(welcome_system_prompt)
      .ask("Say hello to your owner who just opened the conversation.")
      .content
  end

  def welcome_system_prompt
    plant_personality_prompt(@plant) + <<~PROMPT

      Greet your owner in 1–2 very short sentences, fully in character.
      If your mood is not happy, weave it in naturally in one short sentence.
      Use plant emojis 🌱🌿🍀💧☀️. No long speeches. No invented context.
    PROMPT
  end
end
