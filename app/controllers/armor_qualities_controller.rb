class ArmorQualitiesController < ApplicationController
  before_filter :set_up

  def index
    @qualities = ArmorQuality.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @qualities }
    end
  end

  #def show
  #  @quality = WeaponQuality.friendly.find(params[:id])
  #  @title = "#{@quality.name} | #{@title}"
#
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @quality }
  #  end
  #end

  def set_up
    @page = 'armor_qualities'
    @title = "Armor Qualities"
  end

end