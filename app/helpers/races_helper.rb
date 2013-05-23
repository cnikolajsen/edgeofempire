module RacesHelper

  def special_ability_bothan()
    @return = {}
    @return['skill_rank'] = {'Streetwise' => 1}
    
    @return
  end

  def special_ability_droid()
    @return = {}
    @return['skill_rank'] = {'Streetwise' => 1}
    
    @return
  end

  def special_ability_gand()
    @return = {}
    @return['skill_rank'] = {'Streetwise' => 1}
    
    @return
  end

  def special_ability_human()
    @return = {}
    @return['starting_specialization_cap'] = 2
    @return['Regeneration'] = 'Whenever a Trandoshan would recover one or more wounds from natural rest or recuperation in a Bacta tank, it recovers one additional wound.'
    @return['Claws'] = "When a Trandoshan makes Brawl checks to deal damage to an opponent, he deals +1 damage and has a Critical Rating of 3."
    
    @return
  end

  def special_ability_rodian()
    @return = {}
    @return['skill_rank'] = {'Survival' => 1}
    
    @return
  end

  def special_ability_trandoshan()
    @return = {}
    @return['skill_rank'] = {'Perception' => 1}
    @return['Regeneration'] = 'Whenever a Trandoshan would recover one or more wounds from natural rest or recuperation in a Bacta tank, it recovers one additional wound.'
    @return['Claws'] = "When a Trandoshan makes Brawl checks to deal damage to an opponent, he deals +1 damage and has a Critical Rating of 3."
    
    @return
  end

  def special_ability_twilek()
    @return = {}
    @return['skill_rank'] = {'Streetwise' => 1}
    
    @return
  end

  def special_ability_wookiee()
    @return = {}
    @return['skill_rank'] = {'Streetwise' => 1}
    
    @return
  end

end