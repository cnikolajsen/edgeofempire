class CharacterCyberneticsController < ApplicationController
  include CharactersHelper
  before_action :find_character, except: :locations
  before_filter :authenticate_user!, except: :locations
  before_filter :authenticate_owner, except: :locations

  def show
    @character_menu = 'equipment'
    @character_page = 'cybernetics'
    @title = "#{@character.name} | Cybernetics"
    @character_state = character_state(@character)

    @cybernetics_locations = [
      ['Head', 'head'],
      ['Eyes', 'eyes'],
      ['Upper chest', 'upper_chest'],
      ['Lower chest', 'lower_chest'],
      ['Right arm', 'right_arm'],
      ['Left arm', 'left_arm'],
      ['Right hand', 'right_hand'],
      ['Left hand', 'left_hand'],
      ['Right leg', 'right_leg'],
      ['Left leg', 'left_leg']
    ]

    @cybernetics = CharacterCybernetic.where(character_id: @character.id)
    @cybernetics_gear = Gear.joins(:gear_category).where(gear_categories: { name: 'Cybernetics' })
  end

  def update
    if !params[:character_cybernetics][:cybernetics_id].blank? && !params[:character_cybernetics][:location].blank?
      CharacterCybernetic.where(character_id: @character.id, location: params[:character_cybernetics][:location], gear_id: params[:character_cybernetics][:cybernetics_id]).create
    end

    flash[:success] = 'Cybernetics updated'
    redirect_to :back
  end

  def remove
    CharacterCybernetic.find(params[:character_cybernetics_id]).destroy

    flash[:success] = 'Cybernetics removed'
    redirect_to :back
  end

  def locations
    gear = Gear.find(params[:id])
    case "#{gear.name.gsub(/[^0-9a-z\\s]/i, '').downcase}"
    when /^cyberneticweapon/
      @cybernetics_locations = [
        ['Right arm', 'right_arm'],
        ['Left arm', 'left_arm']
      ]
    when /^cyberneticarmmod/
      @cybernetics_locations = [
        ['Right arm', 'right_arm'],
        ['Left arm', 'left_arm']
      ]
    when /^cyberneticlegmod/
      @cybernetics_locations = [
        ['Right leg', 'right_leg'],
        ['Left leg', 'left_leg']
      ]
    when /^cyberneticbrainimplant/
      @cybernetics_locations = [
        %w(Head head)
      ]
    when /^cyberneticeyes/
      @cybernetics_locations = [
        %w(Eyes eyes)
      ]
    when /^implantarmor/
      @cybernetics_locations = [
        ['Upper chest', 'upper_chest'],
        ['Lower chest', 'lower_chest']
      ]
    when /^immuneimplant/
      @cybernetics_locations = [
        ['Upper chest', 'upper_chest'],
        ['Lower chest', 'lower_chest']
      ]
    when /^cyberscannerlimb/
      @cybernetics_locations = [
        ['Right hand', 'right_hand'],
        ['Left hand', 'left_hand']
      ]
    when /avionicsinterface/
      @cybernetics_locations = [
        ['Right hand', 'right_hand'],
        ['Left hand', 'left_hand']
      ]
    else
      @cybernetics_locations = [
        %w(Head head),
        %w(Eyes eyes),
        ['Upper chest', 'upper_chest'],
        ['Lower chest', 'lower_chest'],
        ['Right arm', 'right_arm'],
        ['Left arm', 'left_arm'],
        ['Right hand', 'right_hand'],
        ['Left hand', 'left_hand'],
        ['Right leg', 'right_leg'],
        ['Left leg', 'left_leg']
      ]
    end

    render json: @cybernetics_locations, status: :ok
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
