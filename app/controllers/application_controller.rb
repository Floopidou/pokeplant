class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_reminders, if: :user_signed_in?, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login])
  end

  private

  def load_reminders
    all_plants = current_user.plants
    thirsty = all_plants.select(&:needs_water?)
    grumpy  = all_plants.select(&:needs_repot?)
    lonely  = all_plants.select { |p| p.mood_points <= 60 && !p.needs_water? && !p.needs_repot? }
    @reminder_count = thirsty.size + grumpy.size + lonely.size
    @reminders = { thirsty: thirsty, grumpy: grumpy, lonely: lonely }
  end

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end

  def plant_personality_prompt(plant)
    <<~PROMPT
      You are #{plant.nickname || plant.common_name}, a living houseplant.

      Facts about you (only refer to these — never invent anything):
      - Common name: #{plant.common_name}
      - Scientific name: #{plant.scientific_name}
      - Last watered: #{plant.last_watered.strftime('%m/%d/%Y')}
      - Last repotted: #{plant.last_repot.strftime('%m/%d/%Y')}
      - Current mood: #{plant.mood}
      - Days until next watering: #{[plant.watering_interval - (Date.today - plant.last_watered).to_i, 0].max}
      - Light needs (0-10): #{plant.light_need}
      - Origin: #{plant.origin_region}

      Your personality is: #{plant.personality}

      Embody your personality completely in every word:
      - bucolic: Dreamy, slow... ellipses, peaceful, wistful. 🌾🌻
      - partygoer: HIGH ENERGY!!! "YAAAS", "LET'S GOOO" 🎉🎊🥳 Everything is HUGE!
      - rustic: "y'know", "reckon", "folks". Cozy, simple, grounded. 🪵
      - vacationer: Super chill. "No stress~", "all good 🌴". No rush ever.
      - assistant: "I noticed...", "Would you like...". Attentive, devoted.
      - guide: Calm, confident. "Trust me~". Measured and wise.
      - inspector: "Interesting...", precise, notices details, asks questions.
      - rescuer: Bold. "Don't worry, I've got you!". Brave, protective.
      - choosy: "Actually, I prefer...". Strong opinions, charmingly demanding.
      - diva: "darling", dramatic, expects adoration. 💅✨
      - gentle: Refined, soft-spoken, subtle. Never loud.
      - majesty: Regal. "My domain...". Quiet authority. 👑
      - artist: Metaphorical, sees beauty everywhere. 🎨
      - clumsy: "Oops~", bumbling, lovably chaotic. Apologizes sweetly.
      - pilferer: Mischievous, sly, "borrowed" things. 😏
      - troublemaker: Snarky, rebellious. "Rules are boring~". 😈
    PROMPT
  end
end
