class PlantsController < ApplicationController
  before_action :authenticate_user!

  PERSONALITY_TAGS = %w[
    thunderstorm tornado blizzard drizzle monsoon avalanche glacier
    fog rainbow eclipse tide ember frost pebble cobblestone
    meadow thorn gust dusk ripple
    penguin jellyfish sparrow hamster hedgehog gecko moth raven
    firefly seahorse fox crane beetle ferret capybara
    salamander wren lynx otter magpie
    velvet flannel hammock lampshade lantern compass thimble quill
    mitten satchel locket ribbon candle patchwork cobweb
    tassel inkwell mantle curtain bellows
    biscuit marmalade pickle noodle tangerine crumble cinnamon
    caramel waffle sourdough custard mustard molasses fig marzipan
    wobbly crunchy wistful plucky prickly whimsical peculiar mellow
    frantic restless serene jovial sulky gallant furtive
    Tuesday Wednesday puzzle blip zigzag meander rumble tangle flurry lurk
  ].freeze

  #### THE GARDEN AND INFOS PAGES
  def index
    per_page = 6
    @current_page = (params[:page] || 1).to_i.clamp(1, 4)
    all_plants = current_user.plants.order(position_in_garden: :asc)

    # updating moods
    all_plants.each do |p|
      p.avatar_updating!
    end

    @total_plant_count = all_plants.count
    @paged_plants = all_plants.offset((@current_page - 1) * per_page).limit(per_page)

    thirsty = all_plants.select(&:needs_water?)
    grumpy  = all_plants.select(&:needs_repot?)
    lonely  = all_plants.select { |p| p.mood_points <= 60 && !p.needs_water? && !p.needs_repot? }
    @reminder_count = thirsty.size + grumpy.size + lonely.size
    @reminders = { thirsty: thirsty, grumpy: grumpy, lonely: lonely }
  end

  def show
    @plant = Plant.find(params[:id])
    @plant.avatar_updating!
    plants = current_user.plants.order(:position_in_garden).to_a
    idx = plants.index(@plant)
    @prev_plant = plants[(idx - 1) % plants.size]
    @next_plant = plants[(idx + 1) % plants.size]
  end

  def infos
    @plant = Plant.find(params[:id])
  end

  ### CREATION DE PLANT
  # 1. on prend la photo
  def new
  end

  # 2. A partir de la photo, on lance le llm pour l'identifier avec un service identify_plant
  def create # rubocop:disable Metrics/MethodLength
    photo = params[:photo]

    unless photo.present?
      flash[:alert] = "Please provide a photo of your plant."
      redirect_to new_plant_path
      return
    end

    plant_data = identify_plant(photo.tempfile.path) # POURRAIT ETRE UN SERVICE

    if plant_data.nil?
      flash[:alert] = "Could not identify the plant. Please try again with a clearer photo."
      redirect_to new_plant_path
      return
    end

    ## plant found and identified

    # je prépare la next position sur base de la denrière plante
    next_pos = current_user.plants.maximum(:position_in_garden).to_i + 1

    # hash avec les colonnes nécessaires pour la Plant (sauf user, nickname, ositiob, phot url,avatar img, etc.)
    # D'abord je prends uniquement les colonnes qui devraient être générées par l'ia
    array_of_ai_generated_plant_columns = Plant.column_names - %w[id user_id
                                                                  position_in_garden avatar_img
                                                                  personality_tags personality
                                                                  created_at updated_at]
    # j'en fais un hash avec ces arguments
    partial_plant_hash = plant_data.slice(*array_of_ai_generated_plant_columns)

    @plant = Plant.new(
      user: current_user,
      position_in_garden: next_pos,
      **partial_plant_hash # le ** imbrique le hash dans l'autre hash
    )

    # je met l'avatar correspondant à la plant
    @plant.avatar_setting

    # ---> j'upload la photo
    @plant.photo.attach(params[:photo])

    if @plant.save
      redirect_to choose_name_plant_path(@plant), notice: "#{@plant.common_name} identified and added to your garden!"
    else
      flash[:alert] = "Could not save the plant: #{@plant.errors.full_messages.join(', ')}"
      redirect_to new_plant_path
    end
  end

  # 3. je display avatar_img et je demande le nom
  def choose_name
    @plant = Plant.find(params[:id])
  end

  # 4. je change le nom
  def apply_name
    @plant = Plant.find(params[:id])
    @plant.nickname = params[:nickname]

    if @plant.save
      redirect_to select_tags_plant_path(@plant),
                  notice: "Your #{@plant.common_name} has been named #{@plant.nickname}!"
    else
      flash[:alert] = "Could not save the plant: #{@plant.errors.full_messages.join(', ')}"
      redirect_to choose_name_plant_path
    end
  end

  # 5. je sélectionne les tags
  def select_tags
    @plant = Plant.find(params[:id])
    @tags = PERSONALITY_TAGS.select { |w| w.length <= 7 }.sample(12)
  end

  # 6. je set les tags et lance le sélecteur de personnalités
  def apply_tags
    @plant = Plant.find(params[:id])
    selected = Array(params[:selected_tags]).first(3)
    missing = 3 - selected.size

    if missing.positive?
      flash[:alert] = if missing == 3
                        "Please check 3 words."
                      else
                        "Please check #{missing} more #{missing == 1 ? 'word' : 'words'}."
                      end
      redirect_to select_tags_plant_path(@plant) and return
    end

    string_of_tags = selected.join(", ")
    @plant.personality_tags = string_of_tags
    @plant.personality = personality_setter(@plant.input_date, string_of_tags)

    if @plant.save
      redirect_to plant_path(@plant), notice: "Personality of #{@plant.nickname} has been generated!"
    else
      flash[:alert] = "Could not save the plant: #{@plant.errors.full_messages.join(', ')}"
      redirect_to select_tags_plant_path(@plant)
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @plant = Plant.find(params[:id])
    @plant.destroy

    redirect_to plants_path
  end

  ### CARING FOR THE PLANT
  def care
    @plant = Plant.find(params[:id])
    @plant.avatar_updating!
    @active_tab = params[:tab] || "water"
  end

  def water
    @plant = Plant.find(params[:id])
    @plant.update(last_watered: Date.today)
    @plant.update(mood_points: [@plant.mood_points + 20, 100].min)

    if @plant.save
      redirect_to care_plant_path(@plant, tab: "water"),
                  notice: "#{@plant.nickname} has been watered!"
    else
      flash[:alert] = "Could not water the virtual plant: #{@plant.errors.full_messages.join(', ')}"
      redirect_to care_plant_path(@plant, tab: "water")
    end
  end

  def repot
    @plant = Plant.find(params[:id])
    @plant.update(last_repot: Date.today)
    @plant.update(mood_points: [@plant.mood_points + 20, 100].min)

    if @plant.save
      redirect_to care_plant_path(@plant, tab: "pot"),
                  notice: "#{@plant.nickname} has been repotted!"
    else
      flash[:alert] = "Could not repot the virtual plant: #{@plant.errors.full_messages.join(', ')}"
      redirect_to care_plant_path(@plant, tab: "pot")
    end
  end

  def pet
    @plant = Plant.find(params[:id])
    @plant.mood_points = [@plant.mood_points + 10, 100].min

    respond_to do |format|
      if @plant.save
        format.turbo_stream
        format.html { redirect_to care_plant_path(@plant), notice: "#{@plant.nickname} smiles ❤️" }
      else
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to care_plant_path(@plant), alert: @plant.errors.full_messages.join(", ") }
      end
    end
  end

  private

  ### PLANT CREATION HELPERS
  def identify_plant(image_path) # rubocop:disable Metrics/MethodLength
    prompt = <<~PROMPT
      You are a botanist expert. Analyze this plant photo and return a JSON object with exactly these fields:
      - common_name: string
      - scientific_name: string
      - description: detailed description of the plant (2-3 sentences)
      - light_need: integer from 0 (shade) to 10 (full sun)
      - toxicity: integer from 0 (non-toxic) to 10 (highly toxic)
      - temperature_min: minimum tolerated temperature in Celsius (integer between -20 and 50)
      - temperature_max: maximum tolerated temperature in Celsius (integer between 0 and 100)
      - type_of_soil: recommended soil type (e.g. "well-draining potting mix")
      - optimal_placement: best placement for the plant (e.g. "bright indirect light near a south-facing window")
      - origin_region: geographic region of origin (e.g. "Tropical West Africa")
      - watering_interval: recommended number of days between waterings (integer)
      - repot_interval: recommended number of days between repottings (integer)
      - plant_size: one of "small", "medium", "large", "very_large", "tree"
      - ideal_pot_size: one of "small", "medium", "large", "very_large", "tree"

      Return ONLY valid JSON. No markdown, no code fences, no explanation.
    PROMPT

    chat = RubyLLM.chat(model: "gpt-4o")
    response = chat.ask(prompt, with: { image: image_path })

    JSON.parse(response.content)
  rescue StandardError => e
    Rails.logger.error("Plant identification failed: #{e.message}")
    nil
  end

  def personality_setter(input_date, personality_tags) # rubocop:disable Metrics/MethodLength
    base_prompt = <<~PROMPT
      You are a good mentalist in charge of determining the personality
      of a virtual person in an app

      I am the user in charge of the virtual person and I don't know what their
      personality is

      Among available personalities, you must determine the type of the
      personality that the person has based on its astrological sign,
      knowing it's born on #{input_date}, and based on a few words that makes me think
      of this virtual person, which are #{personality_tags}

      Reply with ONLY the personality name, nothing else.
    PROMPT

    my_llm = RubyLLM.chat(model: "gpt-4o")
    instructed_llm = my_llm.with_instructions(personalities_available)
    response = instructed_llm.ask(base_prompt)
    response.content.strip.downcase
  rescue StandardError => e
    Rails.logger.error("Personality setter failed: #{e.message}")
    nil
  end

  def personalities_available
    <<~PROMPT
      The only possible personalities names for virtual persons are the following, with a description attached that characterize them:
      - Bucolic: Gentle, dreamy souls, quietly enjoying life's peaceful moments from their favorite spot.
      - PartyGoer: Joyful party-starters, they turn every occasion into a lively celebration.
      - Rustic: Warm-hearted and easygoing, these dogs cherish life's simple comforts without fuss.
      - Vacationer: Relaxed and friendly, they delight in life's small pleasures at an easy pace.
      - Assistant: Thoughtful and devoted, they gracefully anticipate your needs with quiet attention.
      - Guide: Quietly confident and independent, they calmly lead the way with steady assurance.
      - Inspector: Sharp-eyed observers, their quiet independence means nothing escapes their notice.
      - Rescuer: Active and protective, they swiftly respond with bravery whenever duty calls.
      - Choosy: Social yet particular, they charmingly, and firmly, make their preferences known.
      - Diva: Sensitive and reserved, these gentle souls expect constant care and affectionate attention.
      - Gentle: Refined and self-assured, they elegantly master the subtle art of discretion.
      - Majesty: Independent and charismatic, they reign serenely over their domain with quiet dignity.
      - Artist: Expressive and spirited, they turn every place into their own creative playground.
      - Clumsy: Affectionate but stubborn, their boundless energy often leads to delightful mishaps.
      - Pilferer: Playful and mischievous, their lively spirit makes them expert thieves of anything enticing.
      - Troublemaker: Free-spirited rebels, joyfully ignoring rules and living life on their own playful terms.
    PROMPT
  end
end
