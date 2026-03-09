Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

rails g model Plant \
position_in_garden:integer \
avatar_img \
nickname \
common_name \
mood_points:integer \
watering_interval:integer \
repot_interval:integer \
last_watered:date \
last_repot:date \
temperature_min:float \
temperature_max:float \
light_need:integer \
toxicity:integer \
type_of_soil \
ideal_pot_size \
optimal_placement \
plant_size \
description:text \
origin_region \
scientific_name \
personality \
input_date:date \
personality_tags \
photo_url \
user:references
