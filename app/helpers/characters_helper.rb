module CharactersHelper

  def character_state(character)
    @return = {}
    @messages = Array.new
    if character.creation?
      flash[:notice] = 'This character is in its creation phase. Special rules may apply.'
    elsif character.active?
      flash[:notice] = 'Character is marked active and can spend experience points normally.'
    elsif character.retired?
      flash[:notice] = 'Character taken off duty and is read only.'
    end

    if character.selected_skill_ranks_career.count > character.free_skill_ranks_career
      state = Hash.new
      state['state_short'] = "missing_free_skills"
      @messages << state
      flash[:error] = "You have selected too many free skill ranks from your career! Please only select #{character.free_skill_ranks_career} free skill ranks from your career."
    end

    if character.selected_skill_ranks_specialization.count > character.free_skill_ranks_specialization
      state = Hash.new
      state['state_short'] = "missing_free_skills"
      @messages << state
      flash[:error] = "You have selected too many free skill ranks from your first specialization! Please only select #{character.free_skill_ranks_specialization} free skill ranks from your first specialization."
    end

    if character.selected_skill_ranks_racial_trait.count > character.free_skill_ranks_racial_trait
      state = Hash.new
      state['state_short'] = "missing_free_skills"
      @messages << state
      flash[:error] = "You have selected too many free skill ranks from your #{character.race.name} trait! Please only select #{character.free_skill_ranks_racial_trait} free skill ranks from your #{character.race.name} trait."
    end

    @messages
  end

  def skill_state(character)
    if character.selected_skill_ranks_career.count < character.free_skill_ranks_career || character.selected_skill_ranks_specialization.count < character.free_skill_ranks_specialization || character.selected_skill_ranks_racial_trait.count < character.free_skill_ranks_racial_trait
      state = Hash.new
      state['state_short'] = "missing_free_skills"
      @messages << state
      racial_trait_text = ''
      if character.free_skill_ranks_racial_trait > 0 && character.selected_skill_ranks_racial_trait.count < character.free_skill_ranks_racial_trait
        racial_trait_text = "<li>Please select #{character.free_skill_ranks_racial_trait} free skill ranks from your #{character.race.name} trait before buying skill ranks.</li>"
      end
      if character.selected_skill_ranks_career.count < character.free_skill_ranks_career
        career_text = "<li>Please select #{character.free_skill_ranks_career} free skill ranks from your career before buying skill ranks.</li>"
      end
      if character.selected_skill_ranks_specialization.count < character.free_skill_ranks_specialization
        specialization_text = "<li>Please select #{character.free_skill_ranks_specialization} free skill ranks from your first specialization before buying skill ranks.</li>"
      end
      flash[:error] = "<ul>#{career_text}#{specialization_text}#{racial_trait_text}</ul>"
    end

  end

  def is_career_skill(skill_id, talent_select = false, character = nil)
    @character = @character ||= character
    # Build an array of career skill ids granted by character's career.
    career_skill_ids = Array.new
    if @character.career
      @character.career.career_skills.each do |skill|
        career_skill_ids << skill.skill_id
      end

      character_specializations = Array.new
      character_specializations << @character.specialization_1
      character_specializations << @character.specialization_2
      character_specializations << @character.specialization_3
      # Then add bonus career skills ids from specializations.
      @character.career.talent_trees.each do |tt|
        if character_specializations.include? tt.id
          tt.talent_tree_career_skills.each do |skill|
            career_skill_ids << skill.skill_id
          end
        end
      end
    end

    # And finally add career skill ids granted by talents.
    if !talent_select
      @character.character_talents.each do |character_talent|
        # Check if the ids for the talents Insight or Well Rounded is selected
        # on the character.
        character_talent.attributes.each do |key, value|
          if key.match(/talent_[\d]_[\d]$/) and !value.nil?
            if value == 80
              unless character_talent["#{key}_options"].nil?
                character_talent["#{key}_options"].each do |skill_id|
                  career_skill_ids << skill_id.to_i
                end
              end
            end
            if value == 111
              career_skill_ids << 18
              career_skill_ids << 27
            end
          end
        end
      end
    end

    career_skill_ids.include?(skill_id)
  end

  def set_experience_cost(character_id, type, resource_id, ranks, direction = 'up', granted_by = '')
    case type
    when 'brawn', 'agility', 'intellect', 'willpower', 'cunning', 'presence'
      if direction == 'up'
        1.upto(ranks) do |rank|
          experience = CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => rank).first_or_create

          if granted_by == 'race' or experience.granted_by == 'race'
            experience.granted_by = 'race'
            experience.cost = 0
          else
            experience.cost = (10 * rank).to_i
          end
          experience.save
        end
      else
        experience = CharacterExperienceCost.where(:character_id => character_id, :resource_type => type).order("rank DESC").first
        experience.rank.downto((experience.rank - ranks + 1)) do |rank|
          CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :rank => rank).delete_all
        end
      end

    when 'talent'
      if granted_by == 'race'
        experience_cost = 0
      else
        experience_cost = ranks * 5
      end
      if direction == 'up'
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks, :cost => experience_cost, :granted_by => granted_by).first_or_create
      else
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks).delete_all
      end

    when 'specialization'
      if direction == 'up'
        specialization = TalentTree.where(:id => resource_id).first
        if ranks == 1
          experience_cost = 0
        else
          if specialization.career_id.blank?
            experience_cost = 10 * ranks
          elsif specialization.career_id == @character.career_id
            experience_cost = 10 * ranks
          else
            experience_cost = (10 * ranks) + 10
          end
        end
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks, :cost => experience_cost, :granted_by => granted_by).first_or_create
      else
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks).delete_all
      end

    when 'skill'
      if direction == 'up'
        if granted_by == 'race' || granted_by == 'racial_trait' || granted_by == 'specialization' || granted_by == 'career'
          experience_cost = 0
        else
          experience_cost = 5 * ranks
          unless is_career_skill(resource_id)
            experience_cost += 5
          end
        end
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks, :cost => experience_cost, :granted_by => granted_by).first_or_create
      else
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks.to_i).delete_all
      end

    when 'force_power'
      if direction == 'up'
        experience_cost = ranks
        ranks = 1
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks, :cost => experience_cost, :granted_by => granted_by).first_or_create
      else
        CharacterExperienceCost.where(:character_id => character_id, :resource_type => type, :resource_id => resource_id, :rank => ranks).delete_all
      end

    when 'force_power_upgrade'
      force_power_cost = CharacterExperienceCost.where(:character_id => character_id, :resource_type => 'force_power', :resource_id => resource_id).first
      if direction == 'up'
        force_power_cost.cost += ranks
      else
        force_power_cost.cost -= ranks
      end
      force_power_cost.save
    end
  end

  def get_experience_cost(type, resource_id, granted_by = '')
    if granted_by.blank?
      CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :resource_id => resource_id).order('rank asc')
    else
      CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :resource_id => resource_id, :granted_by => granted_by).order('rank asc')
    end
  end

  def character_experience_cost
    @character.character_experience_costs.sum(:cost)
  end

  def character_available_experience
    @character.character_adventure_logs.sum(:experience)
  end

  def skill_total_ranks(character_skill)
    character_skill.ranks + character_skill.free_ranks_race + character_skill.free_ranks_specialization + character_skill.free_ranks_career + character_skill.free_ranks_equipment
  end

end
