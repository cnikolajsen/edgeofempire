class CharacterManagerController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_up

  def index
    @characters = Character.where(:true).includes(:user).includes(:race).includes(:career).order(:user_id)

    @races = []
    @careers = []
    Character.group(:race_id).count(:race_id).each do |race_count|
      @races << [Race.find(race_count[0].to_i).name, race_count[1]]
    end
    Character.group(:career_id).count(:career_id).each do |career_count|
      @careers << [Career.find(career_count[0].to_i).name, career_count[1]]
    end
  end

  private

  def set_up
    @page = 'all_characters'
    @title = "All Characters"
  end
end