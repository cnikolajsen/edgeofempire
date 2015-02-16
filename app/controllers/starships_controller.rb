class StarshipsController < InheritedResources::Base
  before_filter :set_starship
  before_action :set_starship, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @starship_categories = StarshipCategory.where(:true).order(:name)
    @starship = Starship.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @starship }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @starship }
    end
  end

  def new
    @starship = Starship.new
  end

  def edit
  end

  def create
    @starship = Starship.new(starship_params)

    respond_to do |format|
      if @starship.save
        format.html { redirect_to starships_path, notice: "#{@starship.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @starship }
      else
        format.html { render action: 'new' }
        format.json { render json: @starship.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @starship.update(starship_params)
        format.html { redirect_to @starship, notice:  "#{@starship.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @starship.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @starship.destroy
    respond_to do |format|
      format.html { redirect_to starships_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_starship
    @starship = Starship.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def starship_params
    params.require(:starship).permit(
      :name, :description, :silhouette, :speed, :handling, :defense_fore,
      :defense_port, :defense_starboard, :defense_aft, :armor,
      :hull_trauma_threshold, :system_strain_threshold, :hard_points,
      :hull_type, :manufacturer, :hyperdrive_class_primary,
      :hyperdrive_class_secondary, :navicomputer, :sensor_range,
      :encumbrance_capacity, :passenger_capacity, :consumables, :cost, :rarity,
      :book_id, :starship_category_id,
      starship_vehicle_weapons_attributes: [
        :id, :vehicle_weapon_id, :starship_id, :mounting, :grouping,
        :retractable, :turret, :_destroy
      ],
      starship_crews_attributes: [
        :id, :starship_id, :description, :qty, :_destroy
      ]
    )
  end

  def set_page
    @page = 'starships'
    @parent_page = 'misc'
  end
end