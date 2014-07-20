class WeaponAttachmentsController < ApplicationController
  before_filter :set_weapon_attachment
  before_action :set_weapon_attachment, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @attachments = WeaponAttachment.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  def new
    @weapon_attachment = WeaponAttachment.new
  end

  def edit
  end

  def create
    @weapon_attachment = WeaponAttachment.new(weapon_attachment_params)

    respond_to do |format|
      if @weapon_attachment.save
        format.html { redirect_to weapon_attachments_path, notice: '#{@weapon_attachment.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @weapon }
      else
        format.html { render action: 'new' }
        format.json { render json: @weapon_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @weapon_attachment.update(weapon_attachment_params)
        format.html { redirect_to weapon_attachments_path, notice:  "#{@weapon_attachment.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @weapon_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @weapon_attachment.destroy
    respond_to do |format|
      format.html { redirect_to weapon_attachments_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_weapon_attachment
    @weapon_attachment = WeaponAttachment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def weapon_attachment_params
    params.require(:weapon_attachment).permit(:name, :description, :price, :hard_points, :damage_bonus,
      weapon_attachment_quality_ranks_attributes: [ :id, :ranks, :weapon_attachment_id, :weapon_quality_id, :_destroy ],
      weapon_attachment_modification_options_attributes: [ :id, :skill_id, :talent_id, :damage_bonus, :weapon_quality_id, :weapon_quality_rank, :custom, :_destroy ])
  end

  def set_page
    @page = 'weapon_attachments'
    @title = "Weapon Attachments"
  end

end