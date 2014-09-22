class CharacterCyberneticsController < ApplicationController
  include CharactersHelper
  before_action :find_character #, :except => [:equipment_selection]

  def show
    @character_menu = 'equipment'
    @character_page = 'cybernetics'
    @title = "#{@character.name} | Cybernetics"
    @character_state = character_state(@character)

    @selected_cybernetics = {
      :head => CharacterCybernetic.where(:character_id => @character.id, :location => 'head').first_or_initialize.gear_id,
      :eyes => CharacterCybernetic.where(:character_id => @character.id, :location => 'eyes').first_or_initialize.gear_id,
      :upper_chest => CharacterCybernetic.where(:character_id => @character.id, :location => 'upper_chest').first_or_initialize.gear_id,
      :lower_chest => CharacterCybernetic.where(:character_id => @character.id, :location => 'lower_chest').first_or_initialize.gear_id,
      :right_arm => CharacterCybernetic.where(:character_id => @character.id, :location => 'right_arm').first_or_initialize.gear_id,
      :left_arm => CharacterCybernetic.where(:character_id => @character.id, :location => 'left_arm').first_or_initialize.gear_id,
      :right_hand => CharacterCybernetic.where(:character_id => @character.id, :location => 'right_hand').first_or_initialize.gear_id,
      :left_hand => CharacterCybernetic.where(:character_id => @character.id, :location => 'left_hand').first_or_initialize.gear_id,
      :right_leg => CharacterCybernetic.where(:character_id => @character.id, :location => 'right_leg').first_or_initialize.gear_id,
      :left_leg => CharacterCybernetic.where(:character_id => @character.id, :location => 'left_leg').first_or_initialize.gear_id,
    }

    @cybernetics_gear = Gear.joins(:gear_category).where(:gear_categories => {:name => 'Cybernetics'})
  end

  def update
    if params[:character_cybernetics][:head]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'head').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:head])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'head').destroy
    end
    if params[:character_cybernetics][:eyes]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'eyes').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:eyes])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'eyes').destroy
    end
    if params[:character_cybernetics][:upper_chest]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'upper_chest').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:upper_chest])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'upper_chest').destroy
    end
    if params[:character_cybernetics][:lower_chest]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'lower_chest').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:lower_chest])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'lower_chest').destroy
    end
    if params[:character_cybernetics][:right_arm]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'right_arm').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:right_arm])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'right_arm').destroy
    end
    if params[:character_cybernetics][:left_arm]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'left_arm').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:left_arm])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'left_arm').destroy
    end
    if params[:character_cybernetics][:right_hand]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'right_hand').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:right_hand])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'right_hand').destroy
    end
    if params[:character_cybernetics][:left_hand]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'left_hand').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:left_hand])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'left_hand').destroy
    end
    if params[:character_cybernetics][:right_leg]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'right_leg').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:right_leg])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'right_leg').destroy
    end
    if params[:character_cybernetics][:left_leg]
      cybernetic = CharacterCybernetic.where(:character_id => @character.id, :location => 'left_leg').first_or_create
      cybernetic.update_attribute(:gear_id, params[:character_cybernetics][:left_leg])
    else
      CharacterCybernetic.where(:character_id => @character.id, :location => 'left_leg').destroy
    end

    flash[:success] = "Cybernetics updated"
    redirect_to :back
  end

private

  def find_character
    character_id = params[:character_id] || params[:id]
    @character = Character.friendly.find(character_id)
  end

end
