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

  def untrain_specialization
    specialization = TalentTree.find(params[:spec_id])
    set_experience_cost('specialization', specialization.id, params[:spec_num], direction = 'down')
    @character["specialization_#{params[:spec_num]}".to_sym] = nil
    @character.save
    CharacterTalent.where(:character_id => @character.id, :talent_tree_id => params[:spec_id]).delete_all
    if params[:spec_num].to_i == 1
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').delete_all
      CharacterExperienceCost.where(:character_id => @character.id, :resource_type => 'skill', :granted_by => 'specialization').delete_all
    end
    redirect_to character_talents_url(:id => @character.id), notice: "#{@character.name} has successfully untrained the #{specialization.name} specialization."
  end

  def learn
    @tree = TalentTree.find_by_id(params[:talent_tree_id])
    @row = params[:row].to_i
    @column = params[:column].to_i
    @character_talent_tree = CharacterTalent.where(:character_id => @character.id, :talent_tree_id => @tree.id).first_or_create

    @character_talent_tree.update_attribute("talent_#{@row}_#{@column}".to_sym, @tree["talent_#{@row}_#{@column}"])
    talent_options = Array.new
    #3.times do |o_key|
    #  unless params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key +1}-option_#{o_key}"].nil?
    #    talent_options << params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key + 1}-option_#{o_key}"] unless params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key + 1}-option_#{o_key}"].empty?
    #  end
    #end
    @character_talent_tree.update_attribute("talent_#{@row}_#{@column}_options".to_sym, talent_options)

    # Save experience entry.
    set_experience_cost('talent', @tree["talent_#{@row}_#{@column}"], @row, 'up', nil)

    respond_to do |format|
      format.js  {}
    end
  end

  def unlearn
    @tree = TalentTree.find_by_id(params[:talent_tree_id])
    @row = params[:row].to_i
    @column = params[:column].to_i
    @character_talent_tree = CharacterTalent.where(:character_id => @character.id, :talent_tree_id => @tree.id).first
    @character_talent_tree.update_attribute("talent_#{@row}_#{@column}".to_sym, nil)
    @character_talent_tree.update_attribute("talent_#{@row}_#{@column}_options".to_sym, nil)

    # Save experience entry.
    set_experience_cost('talent', @tree["talent_#{@row}_#{@column}"], @row, 'down', nil)

    respond_to do |format|
      format.js  {}
    end
  end

private

  def find_character
    @page = 'characters'
    character_id = params[:character_id] || params[:id]
    @character = Character.friendly.find(character_id)
  end

end
