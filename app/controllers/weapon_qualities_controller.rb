class WeaponQualitiesController < ApplicationController
  before_filter :set_up

  def index
    @qualities = WeaponQuality.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @qualities }
    end
  end

  def set_up
    @page = 'weapon_qualities'
    @title = "Weapon Qualities"
  end

end