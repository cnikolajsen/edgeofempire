class CharacterGearsController < ApplicationController
  include CharactersHelper
  before_action :find_character, :except => [:equipment_selection]
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  def show
    @character_menu = 'equipment'
    @character_page = 'gear'
    @title = "#{@character.name} | Equipment"
    @character_state = character_state(@character)
  end

  def equipment_selection
    if params[:gear_id]
      item = Gear.find(params[:gear_id])
      render :partial => "gear_info", :locals => { :gear => item}
    else
      render :partial => "gear_info", :locals => { :gear => nil}
    end
  end

  def add_equipment
    if params[:character_gears]
      item = Gear.find(params[:character_gears][:gear_id]) unless params[:character_gears][:gear_id].blank?

      if item
        character_gear = CharacterGear.where(:character_id => @character.id, :gear => params[:character_gears][:gear_id]).create
        character_gear.update_attribute(:carried, params[:character_gears][:carried])
        character_gear.update_attribute(:qty, params[:character_gears][:qty])
        flash[:success] = "#{item.name} added"
      else
        flash[:error] = "Item not found."
      end
    elsif params[:character_custom_gears]
      @custom_gear = CharacterCustomGear.new(
        :character_id => @character.id,
        :description => params[:character_custom_gears][:description],
        :carried => params[:character_custom_gears][:carried],
        :encumbrance => params[:character_custom_gears][:encumbrance],
        :qty => params[:character_custom_gears][:qty],
      )

      if @custom_gear.save
        flash[:success] = "Custom item added."
      else
        flash[:error] = "Custom item not added. Description can not be blank."
      end
    end
    redirect_to :back
  end

  def increase_equipment_qty
    if params[:custom]
      item = CharacterCustomGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty + 1)
      name = item.description
    else
      item = CharacterGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty + 1)
      name = item.gear.name
    end
    flash[:success] = "'#{name}' count increased"
    redirect_to :back
  end

  def decrease_equipment_qty
    if params[:custom]
      item = CharacterCustomGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty - 1)
      name = item.description
    else
      item = CharacterGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty - 1)
      name = item.gear.name
    end
    flash[:success] = "'#{name}' count decreased"
    redirect_to :back
  end

  def remove_equipment
    if params[:custom]
      item = CharacterCustomGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first
      name = item.description
    else
      item = CharacterGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first
      name = item.gear.name
    end
    item.delete
    flash[:success] = "'#{name}' removed"
    redirect_to :back
  end

  def place_equipment
    if params[:custom]
      item = CharacterCustomGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first

      if params[:action_id] == 'storage'
        item.update_attribute(:carried, :false)
        flash[:success] = "'#{item.description}' moved to storage."
      else
        item.update_attribute(:carried, 1)
        flash[:success] = "'#{item.description}' moved to inventory."
      end
    else
      item = CharacterGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first

      if params[:action_id] == 'storage'
        item.update_attribute(:carried, :false)
        flash[:success] = "'#{item.gear.name}' moved to storage."
      else
        item.update_attribute(:carried, 1)
        flash[:success] = "'#{item.gear.name}' moved to inventory."
      end
    end

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
