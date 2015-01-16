class ArmorAttachmentsController < ApplicationController
  before_filter :set_armor_attachment
  before_action :set_armor_attachment, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource
  skip_authorize_resource :only => :armor_attachment_selection

  def index
    @attachments = ArmorAttachment.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  def new
    @armor_attachment = ArmorAttachment.new
  end

  def edit
  end

  def create
    @armor_attachment = ArmorAttachment.new(armor_attachment_params)

    respond_to do |format|
      if @armor_attachment.save
        format.html { redirect_to armor_attachments_path, notice: "#{@armor_attachment.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @armor }
      else
        format.html { render action: 'new' }
        format.json { render json: @armor_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @armor_attachment.update(armor_attachment_params)
        format.html { redirect_to armor_attachments_path, notice:  "#{@armor_attachment.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @armor_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @armor_attachment.destroy
    respond_to do |format|
      format.html { redirect_to armor_attachments_url }
      format.json { head :no_content }
    end
  end

  def armor_attachment_selection
    unless params[:attachment_id].blank?
      @attachment = ArmorAttachment.find(params[:attachment_id])

      render :partial => "armor_attachment_info", :locals => { :attachment => @attachment, :character_attachment_id => nil, :active => nil, :armor_attachment_options => nil}
    else
      render :partial => "armor_attachment_info", :locals => { :attachment => nil, :character_attachment_id => nil, :active => nil, :armor_attachment_options => nil}
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_armor_attachment
    @armor_attachment = ArmorAttachment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def armor_attachment_params
    params.require(:armor_attachment).permit(:name, :description, :price, :hard_points, :stat_bonus,
      armor_quality_ranks_attributes: [ :id, :ranks, :armor_attachment_id, :armor_quality_id ],
      armor_attachment_modification_options_attributes: [ :id, :skill_id, :talent_id ],
      armor_attachment_attachments_groups_attributes: [ :id, :armor_attachment_id, :attachment_group_id ])
  end

  def set_page
    @page = 'armor_attachments'
    @title = "Armor Attachments"
  end

end