class CharacterSkillsController < ApplicationController
  include CharactersHelper
  before_action :find_character
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  def show
    @character_page = 'skills'
    @title = "#{@character.name} | Skills"
    @character_state = character_state(@character)
    @skill_state = skill_state(@character)

    @skill_select_enabled = true
    @character_state.each do |state|
      if state['state_short'] == "missing_free_skills"
        @skill_select_enabled = false
      end
    end
    free_skill_ranks
  end

  def free_skill_ranks
    @career_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').each do |career_skill|
      @career_free_rank << career_skill.skill_id
    end
    @racial_trait_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'racial_trait').each do |non_career_skill|
      @racial_trait_free_rank << non_career_skill.skill_id
    end

    @initial_talent_tree = nil
    if @character.specialization_1
      @initial_talent_tree = TalentTree.find_by_id(@character.specialization_1)

      @specialization_free_rank = Array.new()
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').each do |career_skill|
        @specialization_free_rank << career_skill.skill_id
      end
    end
  end

  def rank_up
    character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => params[:skill_id]).first
    character_skill.ranks += 1
    character_skill.save

    set_experience_cost(@character.id, 'skill', character_skill.skill_id, skill_total_ranks(character_skill), 'up')

    @skill = Skill.find(params[:skill_id])
    @skill_select_enabled = true
    free_skill_ranks
    #flash[:success] = "#{@skill.name} rank increased"

    respond_to do |format|
      format.js  {}
    end
  end

  def rank_down
    character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => params[:skill_id]).first
    set_experience_cost(@character.id, 'skill', character_skill.skill_id, skill_total_ranks(character_skill), 'down')
    character_skill.ranks -= 1 unless character_skill.ranks == 0
    character_skill.save

    @skill = Skill.find(params[:skill_id])
    @skill_select_enabled = true
    free_skill_ranks
    #flash[:success] = "#{@skill.name} rank decreased"

    respond_to do |format|
      format.js  {}
    end
  end

  def save_free_skill_ranks
    if params[:action] == 'save_free_skill_ranks'

      if params[:free_skill_ranks]
        # Save specialization skills to add a free rank to.
        if params[:free_specialization_skill_ranks]
          specialization_skills = TalentTree.find_by_id(@character.specialization_1).skills
          specialization_skills.each do |skill|
            if params[:free_specialization_skill_ranks].include? skill.id.to_s
              CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'specialization', :ranks => 1).first_or_create
              character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
              if character_skill.free_ranks_specialization == 0 or character_skill.free_ranks_specialization.blank?
                character_skill.free_ranks_specialization = 1
                character_skill.save
              end

              # Check if this skill already has an entry from specialization.
              if get_experience_cost('skill', skill.id, 'specialization').blank?
                # Save experience entry.
                experience_cost = get_experience_cost('skill', skill.id)
                if experience_cost.nil? or experience_cost.blank?
                  set_experience_cost(@character.id, 'skill', skill.id, 1, 'up', 'specialization')
                else
                  set_experience_cost(@character.id, 'skill', skill.id, experience_cost.last.rank + 1, 'up', 'specialization')
                end
              end
            else
              CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'specialization').delete_all
              character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
              unless character_skill.free_ranks_specialization.blank? or character_skill.free_ranks_specialization == 0
                character_skill.free_ranks_specialization -= 1
                character_skill.save
              end

              # Delete experience entry.
              get_experience_cost('skill', skill.id, 'specialization').delete_all
            end
          end
        end

        # Save career skills to add a free rank to.
        if params[:free_career_skill_ranks]
          @character.career.skills.each do |skill|
            if params[:free_career_skill_ranks].include? skill.id.to_s
              CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'career', :ranks => 1).first_or_create
              character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
              if character_skill.free_ranks_career == 0 or character_skill.free_ranks_career.blank?
                character_skill.free_ranks_career = 1
                character_skill.save
              end

              # Check if this skill already has an entry from specialization.
              if get_experience_cost('skill', skill.id, 'career').blank?
                # Save experience entry.
                experience_cost = get_experience_cost('skill', skill.id)
                if experience_cost.nil? or experience_cost.blank?
                  set_experience_cost(@character.id, 'skill', skill.id, 1, 'up', 'career')
                else
                  set_experience_cost(@character.id, 'skill', skill.id, experience_cost.last.rank + 1, 'up', 'career')
                end
              end
            else
              CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'career').delete_all
              character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
              unless character_skill.free_ranks_career.blank? or character_skill.free_ranks_career == 0
                character_skill.free_ranks_career -= 1
                character_skill.save
              end

              # Delete experience entry.
              get_experience_cost('skill', skill.id, 'career').delete_all
            end
          end
        end

        # Save non career skills to add a free rank to. Mainly from racial traits.
        if params[:free_non_career_skill_ranks]
          @character.career.non_career_skills.each do |skill|
            if params[:free_non_career_skill_ranks].include? skill.id.to_s
              CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'racial_trait', :ranks => 1).first_or_create
              character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
              if character_skill.free_ranks_race == 0 or character_skill.free_ranks_race.blank?
                character_skill.free_ranks_race = 1
                character_skill.save
              end

              # Check if this skill already has an entry from specialization.
              if get_experience_cost('skill', skill.id, 'racial_trait').blank?
                # Save experience entry.
                experience_cost = get_experience_cost('skill', skill.id)
                if experience_cost.nil? or experience_cost.blank?
                  set_experience_cost(@character.id, 'skill', skill.id, 1, 'up', 'racial_trait')
                else
                  set_experience_cost(@character.id, 'skill', skill.id, experience_cost.last.rank + 1, 'up', 'racial_trait')
                end
              end
            else
              CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'racial_trait').delete_all
              character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
              unless character_skill.free_ranks_race.blank? or character_skill.free_ranks_race == 0
                character_skill.free_ranks_race -= 1
                character_skill.save
              end

              # Delete experience entry.
              get_experience_cost('skill', skill.id, 'racial_trait').delete_all
            end
          end
        end
      end

      flash[:success] = "Free skill ranks saved"
      redirect_to :back
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
