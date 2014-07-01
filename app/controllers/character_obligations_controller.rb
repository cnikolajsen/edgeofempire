class CharacterObligationsController < ApplicationController
  include CharactersHelper
  before_action :find_character, :except => [:obligation_selection]

  def show
    @character_menu = 'basics'
    @character_page = 'obligation'
    @title = "#{@character.name} | Obligation"
    @character_state = character_state(@character)
  end

  def obligation_selection
    unless params[:obligation_id].blank?
      @obligation = Obligation.find(params[:obligation_id])

      render :partial => "obligation_info", :locals => { :obligation => @obligation, :character_obligation => nil, :active => nil }
    else
      render :partial => "obligation_info", :locals => { :obligation => nil, :character_obligation => nil, :active => nil }
    end
  end

  def add_obligation
    unless params[:character_obligation][:obligation_id].nil?
      @obligation = CharacterObligation.where(:character_id => @character.id, :obligation_id => params[:character_obligation][:obligation_id], :magnitude => 0).create
    end
    flash[:success] = "Obligation added"
    redirect_to :back
  end

  def update_obligation
    unless params[:character_obligation][:character_obligation_id].nil?
      @obligation = CharacterObligation.where(:id => params[:character_obligation][:character_obligation_id]).first
      unless @obligation.nil?
        @obligation.description = params[:character_obligation][:description]
        @obligation.magnitude = params[:character_obligation][:magnitude]
        @obligation.save
      end
    end
    flash[:success] = "Obligation updated"
    redirect_to :back
  end

  def remove_obligation
    CharacterObligation.find(params[:obligation_id]).destroy
    flash[:success] = "Obligation removed"
    redirect_to :back
  end

private

  def find_character
    character_id = params[:character_id] || params[:id]
    @character = Character.friendly.find(character_id)
  end

end
