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

      @character.talent_alterations.each do |talent_id, stat|
        stat.each do |type, value|
          if type == :career_skill
            value.each do |val|
              skill = Skill.where(:name => val).first
              career_skill_ids << skill.id unless skill.nil?
            end
          end
        end
      end

      @character.character_talents.each do |character_talent|
        # Check if the ids for the talent Well Rounded is selected
        # on the character.
        character_talent.attributes.each do |key, value|
          if key.match(/talent_[\d]_[\d]$/) and !value.nil?
            if value == 80
              unless character_talent["#{key}_options"].nil?
                character_talent["#{key}_options"].each do |sid|
                  career_skill_ids << sid.to_i
                end
              end
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
          if specialization.careers.blank?
            experience_cost = 10 * ranks
          elsif specialization.careers.map{|a| a.id}.include? @character.career_id
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
    bonus = 0
    @character.character_obligations.each do |obl|
      case obl.reward
      when 'exp_1'
        bonus = 5
      when 'exp_2'
        bonus = 10
      end
    end
    @character.adventure_logs.sum(:experience) + bonus
  end

  def skill_total_free_ranks(character_skill)
    character_skill.free_ranks_race ||= 0
    character_skill.free_ranks_specialization ||= 0
    character_skill.free_ranks_career ||= 0.to_i
    character_skill.free_ranks_equipment ||= 0
    character_skill.free_ranks_race + character_skill.free_ranks_specialization + character_skill.free_ranks_career + character_skill.free_ranks_equipment
  end

  def skill_total_ranks(character_skill)
    character_skill.ranks.to_i + skill_total_free_ranks(character_skill).to_i
  end

  def character_critical_types(name = nil)
    criticals = []
    criticals << {
      name: 'Minor Nick',
      description: 'The target suffers 1 strain.',
      severity: 1,
      range: '01 - 05'
    }
    criticals << {
      name: 'Slowed Down',
      description: 'The target can only act during the last allied Initiative slot on his next turn.',
      severity: 1,
      range: '06 - 10'
    }
    criticals << {
      name: 'Sudden Jolt',
      description: 'The target drops whatever is in hand.',
      severity: 1,
      range: '11 - 15'
    }
    criticals << {
      name: 'Distracted',
      description: 'The target cannot perform a free maneuver during his next turn.',
      severity: 1,
      range: '16 - 20'
    }
    criticals << {
      name: 'Off-Balance',
      description: 'Add [setback] to his next skill check.',
      severity: 1,
      range: '21 - 25'
    }
    criticals << {
      name: 'Discouraging Wound',
      description: 'Flip one light side Destiny point to a dark side Destiny Point (reverse if NPC).',
      severity: 1,
      range: '26 - 30'
    }
    criticals << {
      name: 'Stunned',
      description: 'The target is staggered until the end of his next turn.',
      severity: 1,
      range: '31 - 35'
    }
    criticals << {
      name: 'Stinger',
      description: 'Increase difficulty of next check by one.',
      severity: 1,
      range: '36 - 40'
    }
    criticals << {
      name: 'Bowled Over',
      description: 'The target is knocked prone and suffers 1 strain.',
      severity: 2,
      range: '41 - 45'
    }
    criticals << {
      name: 'Head Ringer',
      description: 'The target increases the difficulty of all Intellect and Cunning checks by one until the end of the encounter.',
      severity: 2,
      range: '46 - 50'
    }
    criticals << {
      name: 'Fearsome Wound',
      description: 'The target increases the difficulty of all Presence and Willpower checks by one until the end of the encounter.',
      severity: 2,
      range: '51 - 55'
    }
    criticals << {
      name: 'Agonizing Wound',
      description: 'The target increases the difficulty of all Brawn and Agility checks by one until the end of the encounter.',
      severity: 2,
      range: '56 - 60'
    }
    criticals << {
      name: 'Slightly Dazed',
      description: 'The target is disoriented until the end of the encounter.',
      severity: 2,
      range: '61 - 65'
    }
    criticals << {
      name: 'Scattered Senses',
      description: 'The target removes all [boost] from skill checks until the end of the encounter.',
      severity: 2,
      range: '66 - 70'
    }
    criticals << {
      name: 'Hamstrung',
      description: 'The target loses his free maneuver until the end of the encounter.',
      severity: 2,
      range: '71 - 75'
    }
    criticals << {
      name: 'Overpowered',
      description: 'The target leaves himself open, and the attacker may immediately attempt another free attack against him, using the exact same pool as the original attack.',
      severity: 2,
      range: '76 - 80'
    }
    criticals << {
      name: 'Winded',
      description: 'Until the end of the encounter, the target cannot voluntarily suffer strain to activate any abilities or gain additional maneuvers.',
      severity: 2,
      range: '81 - 85'
    }
    criticals << {
      name: 'Compromised',
      description: 'Increase difficulty of all skill checks by one until the end of the encounter.',
      severity: 2,
      range: '86 - 90'
    }
    criticals << {
      name: 'At the Brink',
      description: 'The target suffers 1 strain each time he performs an action.',
      severity: 3,
      range: '91 - 95'
    }
    criticals << {
      name: 'Crippled',
      description: 'One of the target\'s limbs (selected by the GM) is crippled until healed or replaced. Increase difficulty of all checks that require use of that limb by one.',
      severity: 3,
      range: '96 - 100'
    }
    criticals << {
      name: 'Maimed',
      description: 'One of the target\'s limbs (selected by the CM) is permanently lost. Unless the target has a cybernetic replacement, the target cannot perform actions that would require the use of that limb. All other actions gain [setback].',
      severity: 3,
      range: '101 - 105'
    }
    criticals << {
      name: 'Horrific Injury',
      description: 'Randomly roll 1 d 10 to determine one of the target\'s characteristics— 1 -3 for Brawn. 4-6 for Agility, 7 for Intellect, 8 for Cunning, 9 for Presence, 10 for Willpower. Until this Critical Injury is healed, treat that characteristic as one point lower.',
      severity: 3,
      range: '106 - 110'
    }
    criticals << {
      name: 'Temporary Lame',
      description: 'Until this Critical Injury is healed, the target cannot perform more than one maneuver during his turn.',
      severity: 3,
      range: '111 - 115'
    }
    criticals << {
      name: 'Blinded',
      description: 'The target can no longer see. Upgrade the difficulty of all checks twice. Upgrade the difficulty of Perception and Vigilance checks three times.',
      severity: 3,
      range: '116 - 120'
    }
    criticals << {
      name: 'Knocked Senseless',
      description: 'The target is staggered for the remainder of the encounter.',
      severity: 3,
      range: '121 - 125'
    }
    criticals << {
      name: 'Gruesome Injury',
      description: 'Randomly roll 1 d 10 to determine one of the target\'s characteristics— 1 -3 for Brawn. 4-6 for Agility, 7 for Intellect, 8 for Cunning, 9 for Presence, 10 for Willpower. That characteristic is permanently reduced by one, to a minimum of one.',
      severity: 4,
      range: '126 - 130'
    }
    criticals << {
      name: 'Bleeding Out',
      description: 'Every round, the target suffers 1 wound and 1 strain at the beginning of his turn. For every five wounds he suffers beyond his wound threshold, he suffers one additional Critical Injury. Roll on the chart, suffering the injury (if he suffers this result a second time due to this, roll again).',
      severity: 4,
      range: '131 - 140'
    }
    criticals << {
      name: 'The end is Nigh',
      description: 'The target will die after the last Initiative slot during the next round.',
      severity: 4,
      range: '141 - 150'
    }
    criticals << {
      name: 'Dead',
      description: 'Complete, obliterated death.',
      severity: nil,
      range: '151 +'
    }

    if name
      criticals = criticals.select {|crit| crit[:name] == name }
    end

    criticals
  end
end
