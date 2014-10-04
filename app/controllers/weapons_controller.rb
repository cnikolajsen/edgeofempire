class WeaponsController < ApplicationController
  before_filter :set_weapon
  before_action :set_weapon, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @weapon_categories = WeaponCategory.where(:true).order(:name)
    @weapons = Weapon.where(:true).order(:name).includes(:weapon_qualities).includes(:skills)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @weapons }
    end
  end

  def show
    @title = "#{@weapon.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @weapon }
    end
  end

  def new
    @weapon = Weapon.new
  end

  def edit
    if @weapon.weapon_quality_ranks.blank?
      3.times { @weapon.weapon_quality_ranks.build }
    end
  end

  def create
    @weapon = Weapon.new(weapon_params)

    respond_to do |format|
      if @weapon.save
        format.html do
          redirect_to weapons_path, notice: '#{@weapon.name} was successfully created.'
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @weapon.update(weapon_params)
        format.html do
          redirect_to @weapon,
                      notice: "#{@weapon.name} was successfully updated."
        end
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @weapon.destroy
    respond_to do |format|
      format.html { redirect_to weapons_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_weapon
    @weapon = Weapon.friendly.find(params[:id])
  end

  def weapon_params
    params.require(:weapon).permit(
      :crit, :damage, :description, :name, :price, :skill_id, :range,
      :encumbrance, :rarity, :hard_points, :image_url, :weapon_category_id,
      weapon_quality_ranks_attributes: [
        :id, :ranks, :weapon_id, :weapon_quality_id, :_destroy
      ],
      weapon_models_attributes: [
        :id, :weapon_id, :name, :_destroy
      ],
      weapon_attachments_weapons_attributes: [
        :id, :weapon_id, :weapon_attachment_id, :_destroy
      ]
    )
  end

  def set_page
    @page = 'weapons'
    @title = 'Weapons'
  end
end
