class CharacterArmorsController < ApplicationController
  include CharactersHelper
  before_action :find_character
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  def show
    @character_menu = 'equipment'
    @character_page = 'armor'
    @title = "#{@character.name} | Armor"
    @character_state = character_state(@character)
  end

  def add_armor
    if params[:character_armors]
      item = Armor.find(params[:character_armors][:armor_id]) unless params[:character_armors][:armor_id].blank?

      if item
        character_gear = CharacterArmor.where(:character_id => @character.id, :armor => params[:character_armors][:armor_id]).create
        character_gear.update_attribute(:carried, params[:character_armors][:carried])
        character_gear.update_attribute(:equipped, params[:character_armors][:equipped])
        flash[:success] = "#{item.name} added"
      else
        flash[:error] = "Item not found."
      end
    end
    redirect_to :back
  end

  def remove_armor
    item = CharacterArmor.where(:character_id => @character.id, :id => params[:character_armor_id]).first
    name = item.armor.name
    item.delete
    flash[:success] = "'#{name}' removed"
    redirect_to :back
  end

  def place_armor
    item = CharacterArmor.where(:character_id => @character.id, :id => params[:character_armor_id]).first

    if params[:action_id] == 'storage'
      item.update_attribute(:carried, false)
      item.update_attribute(:equipped, false)
      flash[:success] = "'#{item.armor.name}' moved to storage."
    elsif params[:action_id] == 'inventory'
      item.update_attribute(:carried, true)
      flash[:success] = "'#{item.armor.name}' moved to inventory."
    elsif params[:action_id] == 'equip'
      item.update_attribute(:equipped, true)
      flash[:success] = "'#{item.armor.name}' is now equipped."
    elsif params[:action_id] == 'unequip'
      item.update_attribute(:equipped, false)
      flash[:success] = "'#{item.armor.name}' is no longer equipped."
    end

    redirect_to :back
  end

  def armor_attachment
    @character_armor = CharacterArmor.find(params[:character_armor_id])
    @armor = Armor.find(@character_armor.armor_id)
    @title = "#{@character.name} | Armor Attachment"
    @character_state = Array.new

    @armor_attachments = CharacterArmorAttachment.where(:character_armor_id => params[:character_armor_id]).order(:id)

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

  def add_armor_attachment
    unless params[:character_armor_attachment][:armor_attachment_id].blank?
      @armor_attachments = CharacterArmorAttachment.where(:character_armor_id => params[:character_armor_id], :armor_attachment_id => params[:character_armor_attachment][:armor_attachment_id]).first_or_create
      flash[:success] = "Attachment added"
    end
    if params[:character_armor_attachment][:description] || params[:character_armor_attachment][:armor_model_id]
      armor = CharacterArmor.find(params[:character_armor_id])
      armor.update_attribute(:description, params[:character_armor_attachment][:description])
      armor.update_attribute(:armor_model_id, params[:character_armor_attachment][:armor_model_id])
      flash[:success] = 'Character armor updated.'
    end
    redirect_to :back
  end

  def remove_armor_attachment
    CharacterArmorAttachment.where(:id => params[:attachment_id]).destroy_all
    flash[:success] = "Attachment removed"
    redirect_to :back
  end

  def add_armor_attachment_option
    armor_attachment = CharacterArmorAttachment.where(:id => params[:attachment_id]).first

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => @character.id).first
      if character_skill.free_ranks_equipment.nil?
        character_skill.free_ranks_equipment = 1
      else
        character_skill.free_ranks_equipment += 1
      end
      character_skill.save
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
    armor_attachment = CharacterArmorAttachment.where(:id => params[:attachment_id]).first
    armor_attachment.armor_attachment_modification_options.delete_at armor_attachment.armor_attachment_modification_options.index(params[:option_id].to_s)
    armor_attachment.save

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
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
