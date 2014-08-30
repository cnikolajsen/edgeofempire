class RacesController < ApplicationController
  before_filter :set_race
  before_action :set_race, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @races = Race.where(:true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @races }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @race }
    end
  end

  def new
    @race = Race.new
  end

  def edit
  end

  def create
    @race = Race.new(race_params)

    respond_to do |format|
      if @race.save
        format.html { redirect_to races_path, notice: '#{@race.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @race }
      else
        format.html { render action: 'new' }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @race.update(race_params)
        format.html { redirect_to races_path, notice:  "#{@race.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @race.destroy
    respond_to do |format|
      format.html { redirect_to races_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_race
    @race = Race.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def race_params
    params.require(:race).permit(:agility, :brawn, :cunning, :description, :intellect, :name,
    :presence, :special_ability, :starting_experience, :strain_threshold,
    :willpower, :wound_threshold, :image_url,
    race_skills_attributes: [ :id, :race_id, :skill_id, :ranks ],
    race_talents_attributes: [ :id, :race_id, :talent_id, :ranks ])

  end

  def set_page
    @page = 'races'
  end

end