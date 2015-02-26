class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:species, :careers]

  require 'builder'

  def changelog
    @parent_page = 'misc'
    @page = 'changelog'
    @content  = File.read('#{Rails.root}/CHANGELOG.md')
  end

  def species_list
    @species = Race.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @species }
    end
  end

  def human_naming_tables
    @parent_page = 'misc'
    @page = 'human_names'
    @title = 'Human Naming Tables'
    @partial_name = 'human_naming_tables'
    @description = Hash.new()
    @description = [
      'Human names run the gamut of naming conventions. Different cultures use one name, two names, three names, or more; they range from the monosyllabic to the mega-syllabic; some go without consonants or even vowels; and the list of variations goes on. The tables below give some suggestions for generating Human names and should suffice for the average campaign.',
      'Human names in the <em>Star Wars</em> universe can have vastly different meanings depending on the cultures from which they came. Gamemasters and players can assign any meaning they like to these names or simply take them at face value.'
    ]
    @step_one = 'To genereate a Human name, roll once on Table 1 and follow the instructions to generate the character\'s given name. Then roll once on table 4 to generate the character\'s surname.'

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def bothan_naming_tables
    @parent_page = 'misc'
    @page = 'bothan_names'
    @title = 'Bothan Naming Tables'
    @partial_name = 'bothan_naming_tables'
    @description = Hash.new()
    @description = [
      'Something about Bothan names.'
    ]
    @step_one = 'This is how we roll.'

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def rodian_naming_tables
    @parent_page = 'misc'
    @page = 'rodian_names'
    @title = 'Rodian Naming Tables'
    @partial_name = 'rodian_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ''

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def trandoshan_naming_tables
    @parent_page = 'misc'
    @page = 'trandoshan_names'
    @title = 'Trandoshan Naming Tables'
    @partial_name = 'trandoshan_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ''

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def twilek_naming_tables
    @parent_page = 'misc'
    @page = 'twilek_names'
    @title = 'Twi\'lek Naming Tables'
    @partial_name = 'twilek_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ''

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def droid_naming_tables
    @parent_page = 'misc'
    @page = 'droid_names'
    @title = 'Droid Naming Tables'
    @partial_name = 'droid_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ''

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

#  ## @todo This part to be deleted once everything has been entered live.
#  def rules_summary
#    @parent_page = 'misc'
#    @page = 'rules_summary'
#    @title = 'Rules Summary'
#
#    @rules = []
#    @rules << {
#      id: 'thecoremechanics',
#      title: 'The Core Mechanics',
#      text: '
#        The core mechanic of the game revolves around the __skill check__. The skill check determines whether specific actions performed by characters __succeed__ or __fail__, as well as any consequences that may accompany that success or failure.
#
#        1. The player rolls a __pool of dice__ for the skill being tested, along with the dice corresponding to the __difficulty__ of the task, plus any situational dice.\n
#        2. Cancel out all the opposed symbols. If at least one net Success symbol [success] remains, the task succeeds.\n
#        3. Uncanceled Threat [threat] or Advantage [advantage] influence the overall success or failure with positve or negative consequences or side effects.
#      '
#    }
#
#    @rules << {
#      :id => 'thedice',
#      :title => 'The Dice',
#      :text => '<p>When a character makes a skill check, the dice allow him to quickly determine success or failure, as well as magnitude and narrative implications. Besides each skill on the character sheer is a series of icons representing the __dice pool__, such as [ability] [ability] [proficiency]. Below is the key to understanding those icons and the dice they represent.</p>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Ability Dice [ability]</h4>
#          Ability dice form the basis of most dice pools rolled by the players. They represent the character\'s innate ability and characteristics when attempting a skill check.
#        </div>
#      </div>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Proficiency Dice [proficiency]</h4>
#          Proficiency dice stand for the character\'s training and experience and represents how skillful he is at the task at hand.
#        </div>
#      </div>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Boost Dice [boost]</h4>
#          Boost dice are added for positive situational conditions such as having allied assistance, ample time, or the rght equipment to complete a task.
#        </div>
#      </div>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Difficulty Dice [difficulty]</h4>
#          Difficulty dice represent the inherent challenge or complexity of a particular task a character is attempting.
#        </div>
#      </div>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Challenge Dice [challenge]</h4>
#          Challenge dice indicate particularly daunting challenges posed by trained, elite, or prepared opponents.
#        </div>
#      </div>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Setback Dice [setback]</h4>
#          Setback dice are often used to represent relatively minor effects that impair or hinder a character, such as poor lighting, obstructive terrain, or insufficient resources.
#        </div>
#      </div>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Force Dice [force]</h4>
#          Force dice represent the light and dark sides of the Force. In dice pools, ther are generally used only for characters with Force Sensitivity or under special circumstances such as the <a href='#sabacc'>sabacc rules</a>.
#        </div>
#      </div>
#      <div class='dicebox'>
#        <div class='dice-img'></div>
#        <div class='dice-txt'>
#          <h4>Ten-sided Dice</h4>
#          __d100:__ Percentile rolls are used to generate numbers for finding results on tables, such as the severity of a Critical Injury effect.
#        </div>
#      </div>
#      '
#    }
#
#    @rules << {
#      :id => 'dicesymbols',
#      :title => 'Dice Symbols & Results',
#      :text => '<p>The dice used in __Edge of the Empire__ feature a number of unique symbols used to determine success and failure as well as additional context and consequences during task resolution. These symbols allow the players to directly contribute to the story, generating memorable details and describing cinematic actions over the course of their adventures. Below are the definitions of the different symbols, with descriptions of how they may be used in play.</p>
#      <h4>Advantage [advantage]</h4>
#      <p>Advantage [advantage] indicates a positive consequence or side effect that occurs regardless of a task's success or failure, such as slicing a computer in far less time than anticipated or finding an opening during a firefight to duck back into cover. Players typically decide how they want to spend Advantage [advantage] they generate. __Each Advantage [advantage] is cancelled by one Threat [threat].__</p>
#      <h4>Success [success]</h4>
#      <p>If at least one Success [success] remains after all cancellations have been made, the skill check succeeds. The more Success [success] symbols remains, the greater the magnitude of success. During a combat check, each extra success generates one extra damage. __Each Success [success] is cancelled by one Failure [failure].__</p>
#      <h4>Triumph [triumph]</h4>
#      <p>A Triumph [triumph] counts as one Sucesss [success] symbol. In addition, it indicates a spectacularly positive consquence or side effect that occurs regardless of the task's success or failure, such as a Critical Injury with a successful combat check.</p>
#      <h4>Threat [threat]</h4>
#      <p>Threat [threat] indicates negative consequences or side effects that occur regardless of a task's success or failure, e.g. taking longer to slice a computer terminal or leaving an opening in a firefight that allows an enemy to duck into cover. The GM decides how to spend Threat [threat] generated by the PCs. __Each Threat [threat] cancelled by one Advantage [advantage].__</p>
#      <h4>Failure [failure]</h4>
#      <p>__Each Failure [failure] cancels one Success [success].__ Multiple net Failure [failure] symbols do not influence the magnitude of the failure.</p>
#      <h4>Despair [despair]</h4>
#      <p>Despair [despair] counts as one Failure [failure] symbol, in addition to a spectacularly negative consequence that occurs regardless of the task's success or failure.</p>'
#    }
#
#    @rules << {
#      :id => 'upgradingdice',
#      :title => 'Upgrading Dice',
#      :text => '<p>
#        Some game effects call for specific dice in a dice pool to be upgraded. When an Ability die [ability] is upgraded, it is replaced by a Proficiency die [proficiency]. When a Difficulty die [difficulty] is upgraded, it is
#        replaced by a Challenge die [challenge]. First, the player determines how many dice are to be upgraded; then he removes that number of Ability dice [ability] or Difficulty dice [difficulty] from the pool and replaces
#        them with an equal number of Proficiency dice [proficiency] or Challenge dice [challenge].
#      </p>
#      <p>
#        If there are more upgrades to be made than Ability dice [ability] or Difficulty die [difficulty] available in the dice pool, additional upgrades are applied in this order:
#        <ul>
#          <li>1. Another Ability die [ability] or Difficulty die [difficulty] is added to the dice pool. If there are still additional upgrades, proceed to Step 2.</li>
#          <li>2. That Ability die [ability] or Difficulty die [difficulty] is removed, then replaced with a Proficiency die [proficiency] or Challenge die [challenge], respectively. If there are still additional upgrades, repeat Step 1.</li>
#        </ul>
#      </p>'
#    }
#
#    @rules << {
#      :id => 'downgradingdice',
#      :title => 'Downgrading Dice',
#      :text => '<p>Other game effects decrease the difficulty of, or downgrade, a skill check. When a Proficiency die º is downgraded, it is replaced by an Ability die π. When a Challenge die º is downgraded, it becomes
#        a Difficulty die π. First, the player determines how many dice are to be downgraded, then he removes that number of Proficiency dice º or Challenge dice º from the pool and replaces them with an equal
#        number of Ability dice π or Difficulty dice π. Once all downgradeable dice are in their downgraded form, any excess downgrades are ignored.</p>'
#    }
#
#    @rules << {
#      :id => 'buildingdicepool',
#      :title => 'Building the Dice Pool',
#      :text => '<p>To determine a skill check’s dice pool, the player
#compares the character’s skill rank and characteristic
#rating. The higher of the two values determines
#how many Ability dice π are added to the
#skill check’s dice pool. Then the player upgrades
#a number of those Ability dice π into Proficiency
#dice º based on the lower of the two values.
#For instance, a character with Intellect 3 and
#Medicine 1 would have a dice pool of º π π. A
#character with Brawn 2 and Brawl 3 would have a
#dice pool of º º π. If a character has no ranks
#in a skill, he simply rolls a number of Ability dice
#π equal to the related characteristic (found in parentheses
#after each skill).</p>'
#    }
#
#    @rules << {
#      :id => 'difficulty',
#      :title => 'Difficulty',
#      :text => '<p>The player adds a number of Difficulty dice π to his dice
#pool according to the difficulty of the task he is attempting,
#at the discretion of the Game Master. In addition to
#the six different levels of complexity shown here, GMs
#should remember to add Boost dice ∫ and Setback dice
#∫ for additional bonuses and complications arising from
#the environment or circumstances. GMs can also upgrade
#Difficulty dice π into Challenge dice º to denote skilled
#opponents or when Despair μ should be a possibility.
#SIMPLE TASKS (-)
#Routine tasks for which the outcome is rarely in question.
#Usually not rolled unless the GM wishes to determine Initiative
#(see page 8), know the possible magnitude of
#success, or indicate the possibility of complications.
#EASY TASKS (π)
#Picking a primitive lock, tending to minor cuts and
#bruises, finding food and shelter on a lush planet, interacting
#with minions and other faceless NPCs, shooting
#a target at short range.
#AVERAGE TASKS (π π)
#Picking a typical lock, stitching up a small wound, finding
#food and shelter on a temperate planet, interacting
#with rivals and typical NPCs, shooting a target at medium
#range or trying to strike a target while engaged.
#HARD TASKS (π π π)
#Picking a complicated lock, setting broken bones or suturing
#large wounds, finding food and shelter on a rugged
#planet, interacting with charismatic or important
#NPCs, shooting a target at long range.
#DAUNTING TASKS (π π π π)
#Picking an exceptionally sophisticated lock, performing
#surgery or grafting implants, finding food and shelter on
#a barren desert planet, interacting with NPC movers and
#shakers or nemeses, shooting a target at extreme range.
#FORMIDABLE TASKS (π π π π π)
#Picking a lock with no comprehensible mechanism, cloning
#a new body, finding food and shelter on a planet without
#an atmosphere, interacting with heroes and faction leaders.</p>'
#    }
#
#    @rules << {
#      :id => 'characteristics',
#      :title => 'Characteristics',
#      :text => '<p>In Edge of the Empire a character’s intrinsic abilities are
#defined by six characteristics.
#AGILITY
#The Agility characteristic measures a character’s manual
#dexterity, hand-eye coordination, and body control.
#BRAWN
#A character’s Brawn represents a blend of brute power,
#strength, and overall toughness.
#CUNNING
#Cunning reflects how crafty, devious, subtle, and creative
#a character can be.
#INTELLECT
#The Intellect characteristic measures a character’s intelligence,
#education, and ability to reason and rationalize.
#PRESENCE
#A character’s Presence characteristic is a measure of his
#moxie, charisma, confidence, and force of personality.
#WILLPOWER
#The Willpower characteristic reflects a character’s discipline,
#self-control, mental fortitude, and faith.</p>'
#    }
#
#    #@rules << {
#    #  :id => 'combat',
#    #  :title => 'Combat',
#    #  :text => '<p></p>'
#    #}
#
#  end
end
