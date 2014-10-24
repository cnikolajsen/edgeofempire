class AdversaryWeaponsController < ApplicationController
  #include AdversarysHelper
  before_action :find_adversary, :except => [:weapon_attachment_selection]

  def show
    @adversary_menu = 'equipment'
    @adversary_page = 'weapons'
    @title = "#{@adversary.name} | Weapons"
  end

  def weapon_attachment
    @adversary_weapon = AdversaryWeapon.find(params[:adversary_weapon_id])
    @weapon = Weapon.find(@adversary_weapon.weapon_id)
    @title = "#{@adversary.name} | Weapon Attachment"
    @adversary_state = Array.new

    @weapon_attachments = AdversaryWeaponAttachment.where(:adversary_weapon_id => params[:adversary_weapon_id]).order(:id)

    @hard_points_used = 0
    @weapon_attachments.each do |attachment|
      @hard_points_used += WeaponAttachment.where(:id => attachment.weapon_attachment_id).first.hard_points
    end

    @hard_point_meter = ((@hard_points_used.to_f / @weapon.hard_points.to_f) * 100)
    @hard_point_meter_class = ''
    if @hard_point_meter > 100
      @hard_point_meter_class = 'alert'
    end
    if @hard_point_meter == 100
      @hard_point_meter_class = 'success'
    end
  end

  def weapon_attachment_selection
    unless params[:attachment_id].blank?
      @attachment = WeaponAttachment.find(params[:attachment_id])

      render :partial => "weapon_attachment_info", :locals => { :attachment => @attachment, :adversary_attachment_id => nil, :active => nil, :weapon_attachment_options => nil}
    else
      render :partial => "weapon_attachment_info", :locals => { :attachment => nil, :adversary_attachment_id => nil, :active => nil, :weapon_attachment_options => nil}
    end
  end

  def add_weapon_attachment
    @weapon_attachments = AdversaryWeaponAttachment.where(:adversary_weapon_id => params[:adversary_weapon_id], :weapon_attachment_id => params[:adversary_weapon_attachment][:weapon_attachment_id]).first_or_create
    flash[:success] = "Attachment added"
    redirect_to :back
  end

  def remove_weapon_attachment
    AdversaryWeaponAttachment.where(:id => params[:attachment_id]).delete_all
    flash[:success] = "Attachment removed"
    redirect_to :back
  end

  def add_weapon_attachment_option
    weapon_attachment = AdversaryWeaponAttachment.where(:id => params[:attachment_id]).first

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      adversary_skill = AdversarySkill.where(:skill_id => attachment_option.skill_id, :adversary_id => @adversary.id).first
      if adversary_skill.free_ranks_equipment.nil?
        adversary_skill.free_ranks_equipment = 1
      else
        adversary_skill.free_ranks_equipment += 1
      end
      adversary_skill.save
    end

    if weapon_attachment.weapon_attachment_modification_options.nil?
      weapon_attachment.weapon_attachment_modification_options = Array.new
    end
    weapon_attachment.weapon_attachment_modification_options << params[:option_id]
    weapon_attachment.save

    flash[:success] = "Modification option added."
    redirect_to :back
  end

  def remove_weapon_attachment_option
    weapon_attachment = AdversaryWeaponAttachment.where(:id => params[:attachment_id]).first
    weapon_attachment.weapon_attachment_modification_options.delete_at weapon_attachment.weapon_attachment_modification_options.index(params[:option_id].to_s)
    weapon_attachment.save

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
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
