class CharacterTalentsController < ApplicationController
  include CharactersHelper
  before_action :find_character#, :except => [:weapon_attachment_selection]

  def show
    @character_page = 'talents'
    @title = "#{@character.name} | Talents"
    @character_state = character_state(@character)

    @talent_trees = Array.new
    unless @character.specialization_1.nil?
      @talent_trees << TalentTree.find_by_id(@character.specialization_1)

      @specialization_free_rank = Array.new()
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').each do |career_skill|
        @specialization_free_rank << career_skill.skill_id
      end
    end
    unless @character.specialization_2.nil?
      @talent_trees << TalentTree.find_by_id(@character.specialization_2)
    end
    unless @character.specialization_3.nil?
      @talent_trees << TalentTree.find_by_id(@character.specialization_3)
    end
  end

  def learn
    tree = TalentTree.find_by_id(params[:talent_tree_id])
    @character_talent_tree = CharacterTalent.where(:character_id => @character.id, :talent_tree_id => tree.id).first_or_create

    @character_talent_tree.update_attribute("talent_#{params[:row]}_#{params[:column]}".to_sym, tree["talent_#{params[:row]}_#{params[:column]}"])
    talent_options = Array.new
    #3.times do |o_key|
    #  unless params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key +1}-option_#{o_key}"].nil?
    #    talent_options << params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key + 1}-option_#{o_key}"] unless params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key + 1}-option_#{o_key}"].empty?
    #  end
    #end
    @character_talent_tree.update_attribute("talent_#{params[:row]}_#{params[:column]}_options".to_sym, talent_options)

    # Save experience entry.
    set_experience_cost('talent', tree["talent_#{params[:row]}_#{params[:column]}"], params[:row].to_i, 'up', nil)

    flash[:success] = "Talent learned"
    redirect_to :back
    #respond_to do |format|
    #  format.js  {}
    #end
  end

  def unlearn
    tree = TalentTree.find_by_id(params[:talent_tree_id])
    @character_talent_tree = CharacterTalent.where(:character_id => @character.id, :talent_tree_id => tree.id).first
    @character_talent_tree.update_attribute("talent_#{params[:row]}_#{params[:column]}".to_sym, nil)
    @character_talent_tree.update_attribute("talent_#{params[:row]}_#{params[:column]}_options".to_sym, nil)

    # Save experience entry.
    set_experience_cost('talent', tree["talent_#{params[:row]}_#{params[:column]}"], params[:row].to_i, 'down', nil)

    flash[:success] = "Talent unlearned"
    redirect_to :back
    #respond_to do |format|
    #  format.js  {}
    #end
  end

private

  def find_character
    @page = 'characters'
    character_id = params[:character_id] || params[:id]
    @character = Character.friendly.find(character_id)
  end

end
