class ArmorQualitiesController < ApplicationController
  before_filter :set_armor_quality
  before_action :set_armor_quality, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @qualities = ArmorQuality.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @qualities }
    end
  end

  def new
    @armor_quality = ArmorQuality.new
  end

  def edit
  end

  def create
    @armor_quality = ArmorQuality.new(armor_quality_params)

    respond_to do |format|
      if @armor_quality.save
        format.html { redirect_to armor_qualities_path, notice: '#{@armor_quality.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @armor }
      else
        format.html { render action: 'new' }
        format.json { render json: @armor_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @armor_quality.update(armor_quality_params)
        format.html { redirect_to armor_qualities_path, notice:  "#{@armor_quality.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @armor_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @armor_quality.destroy
    respond_to do |format|
      format.html { redirect_to armor_qualities_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_armor_quality
    @armor_quality = ArmorQuality.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def armor_quality_params
    params.require(:armor_quality).permit(:name, :trigger, :description)
  end

  def set_page
    @page = 'armor_qualities'
    @title = "Armor Qualities"
  end

end