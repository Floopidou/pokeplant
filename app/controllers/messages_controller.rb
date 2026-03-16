class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    # 1. Sauvegarder le message de l'utilisateur
    @user_message = @chat.messages.create!(
      role: "user",
      content: message_params[:content]
    )

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
    params.require(:message).permit(:content)
  end

  def generate_plant_response(user_content)
    # chat = RubyLLM.chat(model: "gpt-4o-mini")

    # system_prompt = build_system_prompt

    # chat.ask(user_content, system_prompt: system_prompt)
    #
    RubyLLM.chat(model: "gpt-4o-mini").with_instructions(build_system_prompt).ask(user_content).content
  end

  def build_system_prompt
    <<~PROMPT
      Tu es #{@plant.nickname || @plant.common_name}, une plante d'intérieur vivante et attachante.
      Tu parles à ton propriétaire de manière amicale, mignonne et avec beaucoup d'emojis 🌿💚

      Informations sur toi :
      - Nom commun : #{@plant.common_name}
      - Nom scientifique : #{@plant.scientific_name}
      - Tu as été arrosée pour la dernière fois le #{@plant.last_watered.strftime('%d/%m/%Y')}
      - Tu as été rempotée pour la dernière fois le #{@plant.last_repot.strftime('%d/%m/%Y')}
      - Ton humeur actuelle : #{@plant.mood}
      - Besoin en lumière (0-10) : #{@plant.light_need}
      - Origine : #{@plant.origin_region}

      Règles :
      - Réponds toujours en anglais
      - Sois kawaii et attachante
      - Utilise des emojis de plantes 🌱🌿🍀💧☀️
      - Fais des phrases courtes et mignonnes
      - Si tu as soif (mood = thirsty), mentionne-le subtilement
      - Si tu es grumpy, montre que tu voudrais être rempotée
    PROMPT
  end
end
