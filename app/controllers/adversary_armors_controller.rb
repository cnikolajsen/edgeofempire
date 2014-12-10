class AdversaryArmorsController < ApplicationController
  before_action :find_adversary

  def show
    @adversary_menu = 'equipment'
    @adversary_page = 'armor'
    @title = "#{@adversary.name} | Armor"
  end

  def armor_attachment
    @adversary_armor = AdversaryArmor.find(params[:adversary_armor_id])
    @armor = Armor.find(@adversary_armor.armor_id)
    @title = "#{@adversary.name} | Armor Attachment"
    @adversary_state = Array.new

    @armor_attachments = AdversaryArmorAttachment.where(:adversary_armor_id => params[:adversary_armor_id]).order(:id)

    @hard_points_used = 0
    @armor_attachments.each do |attachment|
      armor_attachment = ArmorAttachment.where(:id => attachment.armor_attachment_id).first
      unless armor_attachment.nil?
        @hard_points_used += ArmorAttachment.where(:id => attachment.armor_attachment_id).first.hard_points
      end
    end

    @hard_point_meter = ((@hard_points_used.to_f / @armor.hard_points.to_f) * 100)
    @hard_point_meter_class = ''
    if @hard_point_meter > 100
      @hard_point_meter_class = 'alert'
    end
    if @hard_point_meter == 100
      @hard_point_meter_class = 'success'
    end
  end

  def armor_attachment_selection
    unless params[:attachment_id].blank?
      @attachment = ArmorAttachment.find(params[:attachment_id])

      render :partial => "armor_attachment_info", :locals => { :attachment => @attachment, :adversary_attachment_id => nil, :active => nil, :armor_attachment_options => nil}
    else
      render :partial => "armor_attachment_info", :locals => { :attachment => nil, :adversary_attachment_id => nil, :active => nil, :armor_attachment_options => nil}
    end
  end

  def add_armor_attachment
    @armor_attachments = AdversaryArmorAttachment.where(:adversary_armor_id => params[:adversary_armor_id], :armor_attachment_id => params[:adversary_armor_attachment][:armor_attachment_id]).first_or_create
    flash[:success] = "Attachment added"
    redirect_to :back
  end

  def remove_armor_attachment
    AdversaryArmorAttachment.where(:id => params[:attachment_id]).destroy_all
    flash[:success] = "Attachment removed"
    redirect_to :back
  end

  def add_armor_attachment_option
    armor_attachment = AdversaryArmorAttachment.where(:id => params[:attachment_id]).first

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      adversary_skill = AdversarySkill.where(:skill_id => attachment_option.skill_id, :adversary_id => @adversary.id).first
      if adversary_skill.free_ranks_equipment.nil?
        adversary_skill.free_ranks_equipment = 1
      else
        adversary_skill.free_ranks_equipment += 1
      end
      adversary_skill.save
    end

    if armor_attachment.armor_attachment_modification_options.nil?
      armor_attachment.armor_attachment_modification_options = Array.new
    end
    armor_attachment.armor_attachment_modification_options << params[:option_id]
    armor_attachment.armor_attachment_modification_options = armor_attachment.armor_attachment_modification_options.uniq
    armor_attachment.save

    flash[:success] = "Modification option added."
    redirect_to :back
  end

  def remove_armor_attachment_option
    armor_attachment = AdversaryArmorAttachment.where(:id => params[:attachment_id]).first
    armor_attachment.armor_attachment_modification_options.delete_at armor_attachment.armor_attachment_modification_options.index(params[:option_id].to_s)
    armor_attachment.save

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      adversary_skill = AdversarySkill.where(:skill_id => attachment_option.skill_id, :adversary_id => @adversary.id).first
      adversary_skill.free_ranks_equipment -= 1
      adversary_skill.save
    end

    flash[:success] = "Modification option removed."
    redirect_to :back
  end

private

  def find_adversary
    adversary_id = params[:adversary_id] || params[:id]
    @adversary = Adversary.friendly.find(adversary_id)
  end


end
