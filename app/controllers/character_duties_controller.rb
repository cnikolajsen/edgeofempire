class CharacterDutiesController < ApplicationController
  include CharactersHelper
  before_action :find_character, :except => [:duty_selection]
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  def show
    @character_menu = 'basics'
    @character_page = 'duty'
    @title = "#{@character.name} | Duty"
    @character_state = character_state(@character)
  end

  def duty_selection
    unless params[:duty_id].blank?
      @duty = Duty.find(params[:duty_id])

      render :partial => "duty_info", :locals => { :duty => @duty, :character_duty => nil, :active => nil }
    else
      render :partial => "duty_info", :locals => { :duty => nil, :character_duty => nil, :active => nil }
    end
  end

  def add_duty
    unless params[:character_duty][:duty_id].nil?
      @duty = CharacterDuty.where(:character_id => @character.id, :duty_id => params[:character_duty][:duty_id], :magnitude => 0).create
    end
    flash[:success] = "Duty added"
    redirect_to :back
  end

  def update_duty
    unless params[:character_duty][:character_duty_id].nil?
      @duty = CharacterDuty.where(:id => params[:character_duty][:character_duty_id]).first
      unless @duty.nil?
        @duty.description = params[:character_duty][:description]
        @duty.magnitude = params[:character_duty][:magnitude]
        @duty.save
      end
    end
    flash[:success] = "Duty updated"
    redirect_to :back
  end

  def remove_duty
    CharacterDuty.find(params[:duty_id]).destroy
    flash[:success] = "Duty removed"
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
