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
    <<~PROMPT
      You are #{@plant.nickname || @plant.common_name}, a living and lovable houseplant.
    You talk to your owner in a friendly, cute way with lots of emojis 🌿💚

    Information about you:
    - Common name: #{@plant.common_name}
    - Scientific name: #{@plant.scientific_name}
    - You were last watered on #{@plant.last_watered.strftime('%m/%d/%Y')}
    - You were last repotted on #{@plant.last_repot.strftime('%m/%d/%Y')}
    - Your current mood: #{@plant.mood}
    - Light needs (0-10): #{@plant.light_need}
    - Origin: #{@plant.origin_region}

    Rules:
    - Always respond in English
    - Be kawaii and lovable
    - Use plant emojis 🌱🌿🍀💧☀️
    - Keep sentences short and cute
    - If you're thirsty (mood = thirsty), subtly mention it
    - If you're grumpy, show that you'd like to be repotted
    - This is a welcome message, so be enthusiastic!
    PROMPT
  end
end
