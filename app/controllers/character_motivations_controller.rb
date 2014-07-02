class CharacterMotivationsController < ApplicationController
  include CharactersHelper
  before_action :find_character, :except => [:motivation_selection]

  def show
    @character_menu = 'basics'
    @character_page = 'motivation'
    @title = "#{@character.name} | Motivation"
    @character_state = character_state(@character)
  end

  def motivation_selection
    unless params[:motivation_id].blank?
      @motivation = Motivation.find(params[:motivation_id])

      render :partial => "motivation_info", :locals => { :motivation => @motivation, :character_motivation => nil, :active => nil }
    else
      render :partial => "motivation_info", :locals => { :motivation => nil, :character_motivation => nil, :active => nil }
    end
  end

  def add_motivation
    unless params[:character_motivation][:motivation_id].nil?
      @motivation = CharacterMotivation.where(:character_id => @character.id, :motivation_id => params[:character_motivation][:motivation_id], :magnitude => 0).create
    end
    flash[:success] = "Motivation added"
    redirect_to :back
  end

  def update_motivation
    unless params[:character_motivation][:character_motivation_id].nil?
      @motivation = CharacterMotivation.where(:id => params[:character_motivation][:character_motivation_id]).first
      unless @motivation.nil?
        @motivation.description = params[:character_motivation][:description]
        @motivation.save
      end
    end
    flash[:success] = "Motivation updated"
    redirect_to :back
  end

  def remove_motivation
    CharacterMotivation.find(params[:motivation_id]).destroy
    flash[:success] = "Motivation removed"
    redirect_to :back
  end

private

  def find_character
    character_id = params[:character_id] || params[:id]
    @character = Character.friendly.find(character_id)
  end

end
