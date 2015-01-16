class CharacterForcePowersController < ApplicationController
  include CharactersHelper
  before_action :find_character, :except => [:force_power_selection]
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  def show
    @character_page = 'forcepowers'
    @title = "#{@character.name} | Force Powers"
    @character_state = character_state(@character)

    @force_powers = CharacterForcePower.where(:character_id => @character.id).order(:id)
  end

  def force_power_selection
    if params[:force_power_id]
      @power = ForcePower.find(params[:force_power_id])

      render :partial => "force_power_info", :locals => { :power => @power, :character_force_power_id => nil, :active => nil, :force_power_upgrades => nil}
    else
      render :partial => "force_power_info", :locals => { :power => nil, :character_force_power_id => nil, :active => nil, :force_power_upgrades => nil}
    end
  end

  def add_force_power
    force_power = ForcePower.find(params[:character_force_power][:force_power_id]) unless params[:character_force_power][:force_power_id].blank?

    if force_power
      CharacterForcePower.where(:character_id => @character.id, :force_power_id => params[:character_force_power][:force_power_id]).first_or_create
      set_experience_cost(@character.id, 'force_power', force_power.id, 10, 'up')
      flash[:success] = "Force Power added"
    else
      flash[:error] = "Force Power not found."
    end
    redirect_to :back
  end

  def remove_force_power
    CharacterForcePower.where(:character_id => @character.id, :force_power_id => params[:force_power_id]).delete_all
    CharacterForcePowerUpgrade.where(:character_id => @character.id, :force_power_id => params[:force_power_id]).delete_all
    set_experience_cost(@character.id, 'force_power', params[:force_power_id], 1, 'down')
    flash[:success] = "Force Power removed"
    redirect_to :back
  end

  def add_force_power_upgrade
    CharacterForcePowerUpgrade.where(:character_id => @character.id, :force_power_id => params[:force_power_id], :force_power_upgrade_id => params[:force_power_upgrade_id]).first_or_create

    @force_powers = CharacterForcePower.where(:character_id => @character.id).order(:id)
    upgrade = ForcePowerUpgrade.where(:id => params[:force_power_upgrade_id]).first
    flash[:success] = "Added <strong>'#{upgrade.name}'</strong> upgrade to the <strong>'#{upgrade.force_power.name}'</strong> Force Power ."
    set_experience_cost(@character.id, 'force_power_upgrade', params[:force_power_id], upgrade.cost, 'up')

    respond_to do |format|
      format.js  {}
    end
  end

  def remove_force_power_upgrade
    CharacterForcePowerUpgrade.where(:character_id => @character.id, :force_power_id => params[:force_power_id], :force_power_upgrade_id => params[:force_power_upgrade_id]).delete_all

    @force_powers = CharacterForcePower.where(:character_id => @character.id).order(:id)
    upgrade = ForcePowerUpgrade.where(:id => params[:force_power_upgrade_id]).first
    flash[:success] = "Removed <strong>'#{upgrade.name}'</strong> upgrade from the <strong>'#{upgrade.force_power.name}'</strong> Force Power ."
    set_experience_cost(@character.id, 'force_power_upgrade', params[:force_power_id], upgrade.cost, 'down')

    respond_to do |format|
      format.js  {}
    end
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
