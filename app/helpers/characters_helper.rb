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

    # Then add bonus career skills ids from specializations.
    @character.career.talent_trees.each do |tt|
      tt.talent_tree_career_skills.each do |skill|
        career_skill_ids << skill.skill_id
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

end
