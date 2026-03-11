class PlantsController < ApplicationController
  before_action :authenticate_user!

  def index
    @plants = current_user.plants.order(position_in_garden: :asc)
  end

  def show
    @plant = Plant.find(params[:id])
  end

  def new
  end

  def create
    photo = params[:photo]

    unless photo.present?
      flash[:alert] = "Please provide a photo of your plant."
      redirect_to new_plant_path and return
    end

    plant_data = identify_plant(photo.tempfile.path)

    if plant_data.nil?
      flash[:alert] = "Could not identify the plant. Please try again with a clearer photo."
      redirect_to new_plant_path and return
    end

    upload_dir = Rails.root.join("public", "uploads", "plants")
    FileUtils.mkdir_p(upload_dir)
    filename = "#{SecureRandom.hex(8)}#{File.extname(photo.original_filename)}"
    FileUtils.cp(photo.tempfile.path, upload_dir.join(filename))

    next_pos = current_user.plants.maximum(:position_in_garden).to_i + 1

    @plant = Plant.new(
      user: current_user,
      nickname: params[:nickname],
      position_in_garden: params[:position_in_garden].presence&.to_i || next_pos,
      avatar_img: "/uploads/plants/#{filename}",
      **plant_data.slice(*Plant.column_names - %w[id user_id avatar_img nickname
                                                  position_in_garden created_at updated_at])
    )

    if @plant.save
      redirect_to @plant, notice: "#{@plant.common_name} identified and added to your garden!"
    else
      flash[:alert] = "Could not save the plant: #{@plant.errors.full_messages.join(', ')}"
      redirect_to new_plant_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def identify_plant(image_path)
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
      - personality: the single best-matching personality for this plant, chosen from: bucolic, partygoer, rustic, vacationer, assistant, guide, inspector, rescuer, choosy, diva, gentle, majesty, artist, clumsy, pilferer, troublemaker
      - personality_tags: 3 to 5 short descriptive personality tags, comma-separated (e.g. "resilient, low-maintenance, dramatic")

      Return ONLY valid JSON. No markdown, no code fences, no explanation.
    PROMPT

    chat = RubyLLM.chat(model: "gpt-4o")
    response = chat.ask(prompt, with: { image: image_path })

    JSON.parse(response.content)
  rescue StandardError => e
    Rails.logger.error("Plant identification failed: #{e.message}")
    nil
  end
end
