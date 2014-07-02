class CharacterWeaponsController < ApplicationController
  include CharactersHelper
  before_action :find_character, :except => [:weapon_attachment_selection]

  def show
    @character_menu = 'equipment'
    @character_page = 'weapons'
    @title = "#{@character.name} | Weapons"
    @character_state = character_state(@character)
  end

  def weapon_attachment
    @character_weapon = CharacterWeapon.find(params[:character_weapon_id])
    @weapon = Weapon.find(@character_weapon.weapon_id)
    @title = "#{@character.name} | Weapon Attachment"
    @character_state = Array.new

    @weapon_attachments = CharacterWeaponAttachment.where(:character_weapon_id => params[:character_weapon_id]).order(:id)

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

      render :partial => "weapon_attachment_info", :locals => { :attachment => @attachment, :character_attachment_id => nil, :active => nil, :weapon_attachment_options => nil}
    else
      render :partial => "weapon_attachment_info", :locals => { :attachment => nil, :character_attachment_id => nil, :active => nil, :weapon_attachment_options => nil}
    end
  end

  def add_weapon_attachment
    @weapon_attachments = CharacterWeaponAttachment.where(:character_weapon_id => params[:character_weapon_id], :weapon_attachment_id => params[:character_weapon_attachment][:weapon_attachment_id]).first_or_create
    flash[:success] = "Attachment added"
    redirect_to :back
  end

  def remove_weapon_attachment
    CharacterWeaponAttachment.where(:id => params[:attachment_id]).delete_all
    flash[:success] = "Attachment removed"
    redirect_to :back
  end

  def add_weapon_attachment_option
    weapon_attachment = CharacterWeaponAttachment.where(:id => params[:attachment_id]).first

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => @character.id).first
      if character_skill.free_ranks_equipment.nil?
        character_skill.free_ranks_equipment = 1
      else
        character_skill.free_ranks_equipment += 1
      end
      character_skill.save
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
    weapon_attachment = CharacterWeaponAttachment.where(:id => params[:attachment_id]).first
    weapon_attachment.weapon_attachment_modification_options.delete_at weapon_attachment.weapon_attachment_modification_options.index(params[:option_id].to_s)
    weapon_attachment.save

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => @character.id).first
      character_skill.free_ranks_equipment -= 1
      character_skill.save
    end

    flash[:success] = "Modification option removed."
    redirect_to :back
  end

private

  def find_character
    character_id = params[:character_id] || params[:id]
    @character = Character.friendly.find(character_id)
  end

end
