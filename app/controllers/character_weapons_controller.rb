class CharacterWeaponsController < ApplicationController
  include CharactersHelper
  before_action :find_character, except: [:weapon_attachment_selection]
  before_filter :authenticate_user!
  before_filter :authenticate_owner, except: [:weapon_attachment_selection]

  def show
    @character_menu = 'equipment'
    @character_page = 'weapons'
    @title = "#{@character.name} | Weapons"
    @character_state = character_state(@character)
  end

  def add_weapon
    if params[:character_weapons]
      item = Weapon.find(params[:character_weapons][:weapon_id]) unless params[:character_weapons][:weapon_id].blank?

      if item
        character_gear = CharacterWeapon.where(:character_id => @character.id, :weapon => params[:character_weapons][:weapon_id]).create
        character_gear.update_attribute(:carried, params[:character_weapons][:carried])
        character_gear.update_attribute(:equipped, params[:character_weapons][:equipped])
        flash[:success] = "#{item.name} added"
      else
        flash[:error] = "Item not found."
      end
    end
    redirect_to :back
  end

  def remove_weapon
    item = CharacterWeapon.where(:character_id => @character.id, :id => params[:character_weapon_id]).first
    name = item.weapon.name
    item.delete
    flash[:success] = "'#{name}' removed"
    redirect_to :back
  end

  def place_weapon
    item = CharacterWeapon.where(:character_id => @character.id, :id => params[:character_weapon_id]).first

    if params[:action_id] == 'storage'
      item.update_attribute(:carried, false)
      item.update_attribute(:equipped, false)
      flash[:success] = "'#{item.weapon.name}' moved to storage."
    elsif params[:action_id] == 'inventory'
      item.update_attribute(:carried, true)
      flash[:success] = "'#{item.weapon.name}' moved to inventory."
    elsif params[:action_id] == 'equip'
      item.update_attribute(:equipped, true)
      flash[:success] = "'#{item.weapon.name}' is now equipped."
    elsif params[:action_id] == 'unequip'
      item.update_attribute(:equipped, false)
      flash[:success] = "'#{item.weapon.name}' is no longer equipped."
    end

    redirect_to :back
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

  def add_weapon_attachment
    character_weapon = CharacterWeapon.find(params[:character_weapon_id])
    unless params[:character_weapon_attachment][:weapon_attachment_id].blank?
      # Check if there are any available hard points left.
      hard_points_used = 0
      CharacterWeaponAttachment.where(:character_weapon_id => params[:character_weapon_id]).order(:id).each do |attachment|
        hard_points_used += WeaponAttachment.where(:id => attachment.weapon_attachment_id).first.hard_points
      end
      weapon = Weapon.find(character_weapon.weapon_id)
      logger.warn(hard_points_used)
      logger.warn(weapon.hard_points)
      if hard_points_used < weapon.hard_points
        @weapon_attachments = CharacterWeaponAttachment.where(:character_weapon_id => params[:character_weapon_id], :weapon_attachment_id => params[:character_weapon_attachment][:weapon_attachment_id]).first_or_create
        flash[:success] = "Attachment added"
      else
        flash[:error] = "No hard points left on item."
      end
    end
    if params[:character_weapon_attachment][:description] || params[:character_weapon_attachment][:weapon_model_id] || params[:character_weapon_attachment][:custom_name]
      character_weapon.update_attribute(:custom_name, params[:character_weapon_attachment][:custom_name])
      character_weapon.update_attribute(:description, params[:character_weapon_attachment][:description])
      character_weapon.update_attribute(:weapon_model_id, params[:character_weapon_attachment][:weapon_model_id])
      flash[:success] = 'Character weapon updated.'
    end
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

  def authenticate_owner
    redirect_to user_character_path(@character.user, @character) unless current_user == @character.user
  end
end
