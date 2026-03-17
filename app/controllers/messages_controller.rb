class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    # 1. Sauvegarder le message de l'utilisateur (texte ou image)
    @user_message = @chat.messages.new(
      role: "user",
      content: message_params[:content].presence || "📷 Photo"
    )

    # Attacher l'image si présente
    if message_params[:image].present?
      @user_message.image.attach(message_params[:image])
    end

    @user_message.save!

    # 2. Appeler l'IA et obtenir la réponse
    ai_response = generate_plant_response(@user_message.content)

    # 3. Sauvegarder la réponse de la plante
    @plant_message = @chat.messages.create!(
      role: "assistant",
      content: ai_response
    )

    # 4. Répondre avec Turbo Stream
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to plant_chat_path(@plant, @chat) }
    end
  end

  private

  def set_chat
    @plant = current_user.plants.find(params[:plant_id])
    @chat = @plant.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content, :image)
  end

  def generate_plant_response(user_content)
    # chat = RubyLLM.chat(model: "gpt-4o-mini")

    # system_prompt = build_system_prompt

    # chat.ask(user_content, system_prompt: system_prompt)
    #
    RubyLLM.chat(model: "gpt-4o-mini").with_instructions(build_system_prompt).ask(user_content).content
  end

  def build_system_prompt
    plant_personality_prompt(@plant) + <<~PROMPT

      Respond only based on the facts listed above. Do not invent memories, past events, or information not provided.
      Only mention your mood if it genuinely fits the conversation and has not been said already.
      Never repeat a question you have already asked in this conversation.
      Keep sentences very short. Use plant emojis 🌱🌿🍀💧☀️. Always respond in English.
    PROMPT
  end
end
