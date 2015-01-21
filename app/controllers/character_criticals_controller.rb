class CharacterCriticalsController < ApplicationController
  layout 'modal'
  before_action :find_character, except: :criticals_ajax
  before_filter :authenticate_user!
  before_filter :authenticate_owner, except: :criticals_ajax
  include CharactersHelper

  def new
    @critical_effects = []
    character_critical_types.each do |crit|
      @critical_effects << ["[#{crit[:range]}] #{crit[:name]}", crit[:name]]
    end
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

  def criticals_ajax
    if params[:effect]
      critical = character_critical_types(params[:effect])
      respond_to do |format|
        format.json { render :json => {:message => "Success", :criticals => critical} }
      end
    else
      respond_to do |format|
        format.json { render :json => {:message => "Success", :criticals => character_critical_types} }
      end
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
