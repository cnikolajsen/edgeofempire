# General equipment.
class GearsController < ApplicationController
  before_filter :set_gear
  before_action :set_gear, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @gear_categories = GearCategory.where(:true).order(:name)
    @gears = Gear.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gears }
    end
  end

  def show
    @title = "#{@gear.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gear }
    end
  end

  def new
    @gear = Gear.new
  end

  def edit
  end

  def create
    @gear = Gear.new(gear_params)

    respond_to do |format|
      if @gear.save
        format.html { redirect_to gears_path, notice: "#{@gear.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @gear }
      else
        format.html { render action: 'new' }
        format.json { render json: @gear.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @gear.update(gear_params)
        format.html { redirect_to @gear, notice:  "#{@gear.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gear.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @gear.destroy
    respond_to do |format|
      format.html { redirect_to gears_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gear
    @gear = Gear.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def gear_params
    params.require(
      :gear).permit(:description, :name, :price, :encumbrance,
                    :rarity, :image_url, :gear_category_id, :book_id,
                    gear_models_attributes: [:id, :gear_id, :name]
    )
  end

  def set_page
    @page = 'gears'
    @title = 'Gear'
  end
end
