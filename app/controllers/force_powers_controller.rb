class ForcePowersController < ApplicationController
  before_filter :set_force_power
  before_action :set_force_power, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @force_powers = ForcePower.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @force_powers }
    end
  end

  def show
    @title = "#{@force_power.name} | #{@title}"

    @upgrades_row_1 = ForcePowerUpgrade.where(:force_power_id => @force_power.id, :row => 1).order(:column)
    @upgrades_row_2 = ForcePowerUpgrade.where(:force_power_id => @force_power.id, :row => 2).order(:column)
    @upgrades_row_3 = ForcePowerUpgrade.where(:force_power_id => @force_power.id, :row => 3).order(:column)
    @upgrades_row_4 = ForcePowerUpgrade.where(:force_power_id => @force_power.id, :row => 4).order(:column)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @force_power }
    end
  end

  def new
    @force_power = ForcePower.new
    @force_power.force_power_upgrades.build
  end

  def edit
  end

  def create
    @force_power = ForcePower.new(force_power_params)

    respond_to do |format|
      if @force_power.save
        format.html do
          redirect_to force_powers_path, notice: '#{@force_power.name} was successfully created.'
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @force_power.update(force_power_params)
        format.html do
          redirect_to @force_power,
                      notice: "#{@force_power.name} was successfully updated."
        end
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @force_power.destroy
    respond_to do |format|
      format.html { redirect_to force_powers_url }
      format.json { head :no_content }
    end
  end

  def force_power_selection
    if params[:force_power_id]
      item = Force_power.find(params[:force_power_id])
      render :partial => "force_power_info", :locals => { :force_power => item}
    else
      render :partial => "force_power_info", :locals => { :force_power => nil}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_force_power
    @force_power = ForcePower.friendly.find(params[:id])
  end

  def force_power_params
    params.require(:force_power).permit(:name, :description, :activation, :ranked,
    force_power_upgrades_attributes: [ :id, :force_power_id, :name, :description, :ranked, :cost, :column, :row, :colspan, :parent_1, :parent_2 ])
  end

  def set_page
    @page = 'force_powers'
  end
end
