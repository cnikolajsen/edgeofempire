module CharactersHelper

  def character_state(character)
    @return = {}
    if character.creation?
      @return['state_short'] = "Creation"
      @return['state_message'] = "This character is in it creation phase. Special rules may apply."
      @return['state_label_class'] = "warning"
      @return['state_alert_class'] = "warning"
    elsif character.active?
      @return['state_short'] = "Active"
      @return['state_message'] = "Character is marked active and can spend experience points normally."
      @return['state_label_class'] = "success"
      @return['state_alert_class'] = "success"
    elsif character.retired?
      @return['state_short'] = "Retired"
      @return['state_message'] = "Character taken off duty and is read only."
      @return['state_label_class'] = "inverse"
      @return['state_alert_class'] = "info"
    end

     @return
  end

  def is_career_skill(skill_id, talent_select = false)
    # Build an array of career skill ids granted by character's career.
    career_skill_ids = Array.new
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

  def character_experience_cost(cid)
    character = Character.find(cid)
    exp_cost = Hash.new

    exp_cost[:header_characteristics] = 0
    # @start Calculate experience spent buying characteristics.
    exp_cost[:brawn] = 0
    exp_cost[:agility] = 0
    exp_cost[:cunning] = 0
    exp_cost[:willpower] = 0
    exp_cost[:intellect] = 0
    exp_cost[:presence] = 0
    character.brawn.times do |time|
      exp_cost[:brawn] += (10 * (time + 1)).to_i
    end
    character.race.brawn.times do |time|
      exp_cost[:brawn] -= (10 * (time + 1)).to_i
    end
    character.agility.times do |time|
      exp_cost[:agility] += 10 * (time + 1)
    end
    character.race.agility.times do |time|
      exp_cost[:agility] -= 10 * (time + 1)
    end
    character.cunning.times do |time|
      exp_cost[:cunning] += 10 * (time + 1)
    end
    character.race.cunning.times do |time|
      exp_cost[:cunning] -= 10 * (time + 1)
    end
    character.willpower.times do |time|
      exp_cost[:willpower] += 10 * (time + 1)
    end
    character.race.willpower.times do |time|
      exp_cost[:willpower] -= 10 * (time + 1)
    end
    character.intellect.times do |time|
      exp_cost[:intellect] += 10 * (time + 1)
    end
    character.race.intellect.times do |time|
      exp_cost[:intellect] -= 10 * (time + 1)
    end
    character.presence.times do |time|
      exp_cost[:presence] += 10 * (time + 1)
    end
    character.race.presence.times do |time|
      exp_cost[:presence] -= 10 * (time + 1)
    end
    # @end Characteristics.

    exp_cost[:header_specializations] = 0
    # @start Calculate experience spent buying specializations.
    unless character.specialization_1.blank?
      specialization = TalentTree.find(character.specialization_1)
      exp_cost["#{specialization.name}".to_sym] = 0
    end
    unless character.specialization_2.blank?
      specialization = TalentTree.find(character.specialization_2)
      non_career_specialization_penalty = 10
      character.career.talent_trees.each do |tree|
        if tree.id == character.specialization_2
          non_career_specialization_penalty = 0
        end
      end
      exp_cost["#{specialization.name}".to_sym] = 20 + non_career_specialization_penalty
    end
    unless character.specialization_3.blank?
      specialization = TalentTree.find(character.specialization_3)
      non_career_specialization_penalty = 10
      character.career.talent_trees.each do |tree|
        if tree.id == character.specialization_3
          non_career_specialization_penalty = 0
        end
      end
      exp_cost["#{specialization.name}".to_sym] = 30 + non_career_specialization_penalty
    end
    # @end Specializations.

    # @start Calculate experience spent buying talents.
    talents = {}
    unless character.character_talents.empty?
      exp_cost[:header_talents] = 0
      character.character_talents.each do |talent_tree|
        talent_tree.attributes.each do |key, value|
          if key.match(/talent_[\d]_[\d]$/) and !value.nil?
            if talents.has_key?(value) && !talent_tree["#{key}_options"].nil?
              talents[value]['count'] = talents[value]['count'] + 1
            else
              talents[value] = {}
              talents[value]['count'] = 1
            end

            talent_cost = 0
            # find the experience cost from the row number in the key.
            # Keys are build like this talent_#{row}_#{column}.
            case key
            when /^talent_1/
              talent_cost = 5
            when /^talent_2/
              talent_cost = 10
            when /^talent_3/
              talent_cost = 15
            when /^talent_4/
              talent_cost = 20
            when /^talent_5/
              talent_cost = 25
            end

            talent = Talent.find(value)
            specialization = TalentTree.find(talent_tree.talent_tree_id)
            exp_cost["#{specialization.name}_#{talent.name}_#{talents[value]['count'].r_to_i}".to_sym] = talent_cost
          end
        end
      end
    end
    # @end Talents.

    # @start Calculate experience spent buying skills.
    unless character.character_skills.empty?
      exp_cost[:header_skills] = 0
      character.character_skills.each do |cs|
        skill = Skill.find(cs.skill_id)
        free_ranks = cs.free_ranks_career + cs.free_ranks_specialization + cs.free_ranks_race
        skill_cost = 0
        cs.ranks.times do |rank|
          skill_cost += (5 * (rank + 1)).to_i
        end
        free_ranks.times do |rank|
          skill_cost -= (5 * (rank + 1)).to_i
        end

        unless skill_cost == 0
          exp_cost["#{cs.ranks - free_ranks}_#{'rank'.pluralize(cs.ranks)}_in_#{skill.name}".to_sym] = skill_cost
        end
      end
    end
    # @end Skills.

    # Sum up the total.
    exp_cost[:total_cost] = exp_cost.inject(0){|a,(_,b)|a+b}

    exp_cost
  end

end
