class CharacterCriticalsController < ApplicationController
  layout 'modal'
  before_action :find_character
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  def new
  end

  def add
    if params[:character_criticals][:effect].blank?
      flash[:error] = 'Select critical'
    else
      CharacterCritical.where(character_id: @character.id, effect: params[:character_criticals][:effect], description: params[:character_criticals][:description], severity: params[:character_criticals][:severity]).create
      flash[:success] = 'Critical added'
    end
    redirect_to :back
  end

  def heal
    CharacterCritical.find(params[:critical_id]).destroy
    flash[:success] = 'Critical healed'
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
