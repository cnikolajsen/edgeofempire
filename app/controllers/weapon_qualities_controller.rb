class WeaponQualitiesController < ApplicationController
  before_filter :set_weapon_quality
  before_action :set_weapon_quality, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource
  #load_and_authorize_resource param_method: 'permitted_params.weapon_quality'

  def index
    @qualities = WeaponQuality.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @qualities }
    end
  end

  def new
    @weapon_quality = WeaponQuality.new
  end

  def edit
  end

  def create
    @weapon_quality = WeaponQuality.new(weapon_quality_params)

    respond_to do |format|
      if @weapon_quality.save
        format.html { redirect_to weapon_qualities_path, notice: '#{@weapon_quality.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @weapon }
      else
        format.html { render action: 'new' }
        format.json { render json: @weapon_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @weapon_quality.update(weapon_quality_params)
        format.html { redirect_to weapon_qualities_path, notice:  "#{@weapon_quality.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @weapon_quality.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @weapon_quality.destroy
    respond_to do |format|
      format.html { redirect_to weapon_qualities_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_weapon_quality
    @weapon_quality = WeaponQuality.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def weapon_quality_params
    params.require(:weapon_quality).permit(:name, :trigger, :description)
  end

  def set_page
    @page = 'weapon_qualities'
    @title = "Weapon Qualities"
  end

end