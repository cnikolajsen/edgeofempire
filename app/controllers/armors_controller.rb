class ArmorsController < ApplicationController
  before_filter :set_armor
  before_action :set_armor, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @armor_categories = ArmorCategory.where(:true).order(:name)
    @armor = Armor.where(:true).order(:name).includes(:armor_qualities).includes(:skills)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @armor }
    end
  end

  def show
    @title = "#{@armor.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @armor }
    end
  end

  def new
    @armor = Armor.new
  end

  def edit
  end

  def create
    @armor = Armor.new(armor_params)

    respond_to do |format|
      if @armor.save
        format.html { redirect_to armors_path, notice: '#{@armor.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @armor }
      else
        format.html { render action: 'new' }
        format.json { render json: @armor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @armor.update(armor_params)
        format.html { redirect_to @armor, notice:  "#{@armor.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @armor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @armor.destroy
    respond_to do |format|
      format.html { redirect_to armors_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_armor
    @armor = Armor.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def armor_params
    params.require(:armor).permit(:name, :description, :defense, :soak, :price, :encumbrance,
    :rarity, :hard_points, :image_url, :armor_category_id,
    armor_models_attributes: [ :id, :armor_id, :name ],
    armor_attachments_armors_attributes: [ :id, :armor_id, :armor_attachment_id ],
    armor_attachments_groups_attributes: [ :id, :armor_id, :attachment_group_id ])
  end

  def set_page
    @page = 'armor'
  end

end