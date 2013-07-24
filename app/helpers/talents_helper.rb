module TalentsHelper

  def talent_parser_armormaster(count)
    @return = {}
    @return[:soak] = count

    @return
  end

  def talent_parser_deadlyaccuracy(count)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill
    @return[:on_purchase][:select_options] = [["Choose a combat skill", ""], 'Brawl', 'Gunnery', 'Melee', 'Ranged (Heavy)', 'Ranged (Light)']

    @return
  end

  def talent_parser_dedication(count)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_characteristic
    @return[:on_purchase][:select_options] = [["Select characteristic", ""], ["Brawn", "brawn"], ["Agility", "agility"], ["Intellect", "intellect"], ["Cunning", "cunning"], ["Willpower", "willpower"], ["Presence", "presence"]]

    @return
  end

  def talent_parser_enduring(count)
    @return = {}
    @return[:soak] = count

    @return
  end

  def talent_parser_forcerating(count)
    @return = {}
    @return[:force_rating] = count

    @return
  end

  def talent_parser_grit(count)
    @return = {}
    @return[:strain] = count

    @return
  end

  def talent_parser_insight(count)
    @return = {}
    @return[:career_skill] = ['perception', 'vigilance']

    @return
  end

  def talent_parser_knowledgespecialization(count)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill
    skills = Skill.where("name LIKE 'Knowledge%'")
    options = Hash.new
    skills.each do |skill|
    #  options[] = skill.name
    end
    @return[:on_purchase][:select_options] = [["Select knowledge", ""], ["Knowledge 1", "knowledge_1"], ["Knowledge 2", "knowledge_2"]]

    @return
  end

  def talent_parser_sixthsense(count)
    @return = {}
    @return[:ranged_defense] = count

    @return
  end

  def talent_parser_smoothtalker(count)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 1
    @return[:on_purchase][:type] = :select_skill
    @return[:on_purchase][:select_options] = [['Choose a skill', ''], 'Charm', 'Coerce', 'Negotiate', 'Deceit']

    @return
  end

  def talent_parser_superiorreflexes(count)
    @return = {}
    @return[:melee_defense] = count

    @return
  end

  def talent_parser_toughened(count)
    @return = {}
    @return[:wound] = count

    @return
  end

  def talent_parser_wellrounded(count)
    @return = {}
    @return[:on_purchase] = {}
    @return[:on_purchase][:amount] = 2
    @return[:on_purchase][:type] = :select_skill
    @return[:on_purchase][:select_options] = [["Select skill", ""], ["Skill 1", "skill_1"], ["Skill 2", "skill_2"]]
    #TODO build a hash of available skills not already a career skill.

    @return
  end
end