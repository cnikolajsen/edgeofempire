module CharactersHelper

  def character_state(character)
    @return = {}
    if character.creation?
      @return['state_short'] = "Creation"
      @return['state_message'] = "This character is in it creation phase. Special rules may apply."
      @return['state_label_class'] = "alert"
      @return['state_alert_class'] = "warning"
    elsif character.active?
      @return['state_short'] = "Active"
      @return['state_message'] = "Character is marked active and can spend experience points normally."
      @return['state_label_class'] = "success"
      @return['state_alert_class'] = "success"
    elsif character.retired?
      @return['state_short'] = "Retired"
      @return['state_message'] = "Character taken off duty and is read only."
      @return['state_label_class'] = "secondary"
      @return['state_alert_class'] = "info"
    end

     @return
  end

  def is_career_skill(skill_id, talent_select = false)
    # Build an array of career skill ids granted by character's career.
    career_skill_ids = Array.new
    unless @character.career.nil?
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

  def set_experience_cost(type, resource_id, ranks, direction = 'up', granted_by = '')
    case type
    when 'brawn', 'agility', 'intellect', 'willpower', 'cunning', 'presence'
      if direction == 'up'
        1.upto(ranks) do |rank|
          experience = CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :resource_id => resource_id, :rank => rank).first_or_create

          if granted_by == 'race' or experience.granted_by == 'race'
            experience.granted_by = 'race'
            experience.cost = 0
          else
            experience.cost = (10 * rank).to_i
          end
          experience.save
        end
      else
        experience = CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type).order("rank DESC").first
        experience.rank.downto((experience.rank - ranks + 1)) do |rank|
          CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :rank => rank).delete_all
        end
      end

    when 'talent'
      if granted_by == 'race'
        experience_cost = 0
      else
        experience_cost = ranks * 5
      end
      if direction == 'up'
        CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :resource_id => resource_id, :rank => ranks, :cost => experience_cost, :granted_by => granted_by).first_or_create
      else
        CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :resource_id => resource_id, :rank => ranks).delete_all
      end

    when 'specialization'

    when 'skill'
      if granted_by == 'race' or granted_by == 'specialization' or granted_by == 'career'
        experience_cost = 0
      else
        experience_cost = 5 * ranks
        unless is_career_skill(resource_id)
          experience_cost += 5
        end
      end

      if direction == 'up'
        CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :resource_id => resource_id, :rank => ranks, :cost => experience_cost, :granted_by => granted_by).first_or_create
      else
        CharacterExperienceCost.where(:character_id => @character.id, :resource_type => type, :resource_id => resource_id, :rank => ranks).delete_all
      end
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
    starting_experience = if !@character.race.nil? then @character.race.starting_experience else 0 end
    earned_experience = @character.experience

    starting_experience + earned_experience
  end

  def skill_total_ranks(character_skill)
    character_skill.ranks + character_skill.free_ranks_race + character_skill.free_ranks_specialization + character_skill.free_ranks_career + character_skill.free_ranks_equipment
  end

end
