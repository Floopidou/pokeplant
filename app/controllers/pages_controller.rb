class PagesController < ApplicationController
  skip_before_action :load_reminders, only: [:loading, :home]

  def home
  end

  def loading
  end

  def all_reminders
    user_plants = current_user.plants
  end
end
