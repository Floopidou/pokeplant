class PagesController < ApplicationController
  def home
  end

  def loading
  end

  def all_reminders
    user_plants = current_user.plants
  end
end
