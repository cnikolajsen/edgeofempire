class CharacterTalentsController < ApplicationController
  include CharactersHelper
  before_action :find_character

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
    set_experience_cost(@character.id, 'specialization', specialization.id, params[:spec_num], 'down')
    @character["specialization_#{params[:spec_num]}".to_sym] = nil
    @character.save
    CharacterTalent.where(character_id: @character.id, talent_tree_id: params[:spec_id]).delete_all
    if params[:spec_num].to_i == 1
      CharacterStartingSkillRank.where(character_id: @character.id, granted_by: 'specialization').delete_all
      CharacterExperienceCost.where(character_id: @character.id, resource_type: 'skill', granted_by: 'specialization').delete_all
    end

    # Delete all talent experience entries and recalculate.
    CharacterExperienceCost.where(character_id: @character.id, resource_type: 'talent').delete_all
    unless @character.character_talents.empty?
      @character.character_talents.each do |talent_tree|
        talent_tree.attributes.each do |key, talent_id|
          if key.match(/talent_[\d]_[\d]$/) && !talent_id.nil?
            row = key.scan(/\d/)[0].to_i
            set_experience_cost(@character.id, 'talent', talent_id, row, 'up', nil)
          end
        end
      end
    end

    redirect_to user_character_talents_path(current_user, @character), notice: "#{@character.name} has successfully untrained the #{specialization.name} specialization."
  end

  def learn
    @tree = TalentTree.find_by_id(params[:talent_tree_id])
    @row = params[:row].to_i
    @column = params[:column].to_i
    @character_talent_tree = CharacterTalent.where(:character_id => @character.id, :talent_tree_id => @tree.id).first_or_create

    @character_talent_tree.update_attribute("talent_#{@row}_#{@column}".to_sym, @tree["talent_#{@row}_#{@column}"])
    talent_options = Array.new
    unless @character_talent_tree["talent_#{@row}_#{@column}_options"].nil?
      @character_talent_tree["talent_#{@row}_#{@column}_options"].each_with_index do |option, index|
        talent_options[index] = option
      end
    end
    if params[:option]
      talent_options[params[:option].to_i] = params[:option_value]
    end
    @character_talent_tree.update_attribute("talent_#{@row}_#{@column}_options".to_sym, talent_options)

    # Save experience entry.
    set_experience_cost(@character.id, 'talent', @tree["talent_#{@row}_#{@column}"], @row, 'up', nil)

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
    set_experience_cost(@character.id, 'talent', @tree["talent_#{@row}_#{@column}"], @row, 'down', nil)

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
