class VehicleWeaponsController < InheritedResources::Base
  before_filter :set_vehicle_weapon
  before_action :set_vehicle_weapon, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @vehicle_weapon = VehicleWeapon.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vehicle_weapon }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vehicle_weapon }
    end
  end

  def new
    @vehicle_weapon = VehicleWeapon.new
  end

  def edit
  end

  def create
    @vehicle_weapon = VehicleWeapon.new(vehicle_weapon_params)

    respond_to do |format|
      if @vehicle_weapon.save
        format.html { redirect_to vehicle_weapons_path, notice: "#{@vehicle_weapon.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @vehicle_weapon }
      else
        format.html { render action: 'new' }
        format.json { render json: @vehicle_weapon.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vehicle_weapon.update(vehicle_weapon_params)
        format.html { redirect_to vehicle_weapons_path, notice:  "#{@vehicle_weapon.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vehicle_weapon.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vehicle_weapon.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_weapons_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_vehicle_weapon
    @vehicle_weapon = VehicleWeapon.friendly.find(params[:id])
    #@vehicle_weapon = Vehicle_weapon.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def vehicle_weapon_params
    params.require(:vehicle_weapon).permit(
      :name, :range, :damage, :critical, :price, :rarity, :size_high, :size_low,
      vehicle_weapon_quality_ranks_attributes: [
        :id, :vehicle_weapon_id, :weapon_quality_id, :ranks, :_destroy
      ]
    )
  end

  def set_page
    @page = 'vehicle_weapons'
    @parent_page = 'misc'
  end
end