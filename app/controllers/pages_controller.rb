class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:species, :careers]
  
  require 'builder'

  def home
    @page = 'home'
    @title = "Edge of the Empire Dummy Frontpage"
  end

  def species_list
    @species = Race.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @species }
    end
  end

  def equipment_list
    @equipment = '' #Equipment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @equipment }
    end
  end

  def human_naming_tables
    @parent_page = 'misc'
    @page = 'human_names'
    @title = "Human Naming Tables"
    @partial_name = 'human_naming_tables'
    @description = Hash.new()
    @description = [
      "Human names run the gamut of naming conventions. Different cultures use one name, two names, three names, or more; they range from the monosyllabic to the mega-syllabic; some go without consonants or even vowels; and the list of variations goes on. The tables below give some suggestions for generating Human names and should suffice for the average campaign.",
      "Human names in the <em>Star Wars</em> universe can have vastly different meanings depending on the cultures from which they came. Gamemasters and players can assign any meaning they like to these names or simply take them at face value."
    ]
    @step_one = "To genereate a Human name, roll once on Table 1 and follow the instructions to generate the character's given name. Then roll once on table 4 to generate the character's surname."

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def bothan_naming_tables
    @parent_page = 'misc'
    @page = 'bothan_names'
    @title = "Bothan Naming Tables"
    @partial_name = 'bothan_naming_tables'
    @description = Hash.new()
    @description = [
      "Something about Bothan names."
    ]
    @step_one = "This is how we roll."
    
    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def rodian_naming_tables
    @parent_page = 'misc'
    @page = 'rodian_names'
    @title = "Rodian Naming Tables"
    @partial_name = 'rodian_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""
    
    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def trandoshan_naming_tables
    @parent_page = 'misc'
    @page = 'trandoshan_names'
    @title = "Trandoshan Naming Tables"
    @partial_name = 'trandoshan_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def twilek_naming_tables
    @parent_page = 'misc'
    @page = 'twilek_names'
    @title = "Twi'lek Naming Tables"
    @partial_name = 'twilek_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def droid_naming_tables
    @parent_page = 'misc'
    @page = 'droid_names'
    @title = "Droid Naming Tables"
    @partial_name = 'droid_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""

    respond_to do |format|
      format.html {render :template => '/pages/naming_tables'}
    end
  end

  def rules_summary
    @parent_page = "misc"
    @page = "rules_summary"
    @title = "Rules Summary"
    
    @rules = Array.new
    @rules << {
      :id => "thecoremechanics",
      :title => "The Core Mechanics",
      :text => "<p>The core mechanic of the game revolves around the <strong>skill check</strong>. The skill check determines whether specific actions performed by characters <strong>succeed</strong> or <strong>fail</strong>, as well as any consequences that may accompany that success or failure.</p>
      <ol><li>The player rolls a <strong>pool of dice</strong> for the skill being tested, along with the dice corresponding to the <strong>difficulty</strong> of the task, plus any situational dice.</li>
      <li>Cancel out all the opposed symbols. If at least one net Success symbol [success] remains, the task succeeds.</li>
      <li>Uncanceled Threat [threat] or Advantage [advantage] influence the overall success or failure with positve or negative consequences or side effects.</li></ol"
    }
    
    @rules << {
      :id => "thedice",
      :title => "The Dice",
      :text => "<p>When a character makes a skill check, the dice allow him to quickly determine success or failure, as well as magnitude and narrative implications. Besides each skill on the character sheer is a series of icons representing the <strong>dice pool</strong>, such as [ability] [ability] [proficiency]. Below is the key to understanding those icons and the dice they represent.</p>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Ability Dice [ability]</h4>
          Ability dice form the basis of most dice pools rolled by the players. They represent the character's innate ability and characteristics when attempting a skill check.
      </div>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Proficiency Dice [proficiency]</h4>
          Proficiency dice stand for the character's training and experience and represents how skillful he is at the task at hand.
      </div>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Boost Dice [boost]</h4>
          Boost dice are added for positive situational conditions such as having allied assistance, ample time, or the rght equipment to complete a task.
      </div>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Difficulty Dice [difficulty]</h4>
          Difficulty dice represent the inherent challenge or complexity of a particular task a character is attempting.
      </div>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Challenge Dice [challenge]</h4>
          Challenge dice indicate particularly daunting challenges posed by trained, elite, or prepared opponents.
      </div>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Setback Dice [setback]</h4>
          Setback dice are often used to represent relatively minor effects that impair or hinder a character, such as poor lighting, obstructive terrain, or insufficient resources.
      </div>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Force Dice [force]</h4>
          Force dice represent the light and dark sides of the Force. In dice pools, ther are generally used only for characters with Force Sensitivity or under special circumstances such as the <a href='#sabacc'>sabacc rules</a>.
      </div>
      <div class='dicebox'>
        <div class='dice-img'></div>
        <div class='dice-txt'>
          <h4>Ten-sided Dice</h4>
          <strong>d100:</strong> Percentile rolls are used to generate numbers for finding results on tables, such as the severity of a Critical Injury effect.
      </div>
      "
    }
    
    @rules << {
      :id => 'dicesymbols',
      :title => 'Dice Symbols & Results',
      :text => "<p>The dice used in <strong>Edge of the Empire</strong> feature a number of unique symbols used to determine success and failure as well as additional context and consequences during task resolution. These symbols allow the players to directly contribute to the story, generating memorable details and describing cinematic actions over the course of their adventures. Below are the definitions of the different symbols, with descriptions of how they may be used in play.</p>
      <h4>Advantage [advantage]</h4>
      Advantage [advantage] indicates a positive consequence or side effect that occurs regardless of a task's success or failure, such as slicing a computer in far less time than anticipated or finding an opening during a firefight to duck back into cover. Players typically decide how they want to spend Advantage [advantage] they generate. <strong>Each Advantage [advantage] is cancelled by one Threat [threat].</strong>
      <h4>Success [success]</h4>
      If at least one Success [success] remains after all cancellations have been made, the skill check succeeds. The more Success [success] symbols remains, the greater the magnitude of success. During a combat check, each extra success generates one extra damage. <strong>Each Success [success] is cancelled by one Failure [failure].</strong>
      <h4>Triumph [triumph]</h4>
      A Triumph [triumph] counts as one Sucesss [success] symbol. In addition, it indicates a spectacularly positive consquence or side effect that occurs regardless of the task's success or failure, such as a Critical Injury with a successful combat check.
      <h4>Threat [threat]</h4>
      Threat [threat] indicates negative consequences or side effects that occur regardless of a task's success or failure, e.g. taking longer to slice a computer terminal or leaving an opening in a firefight that allows an enemy to duck into cover. The GM decides how to spend Threat [threat] generated by the PCs. <strong>Each Threat [threat] cancelled by one Advantage [advantage].</strong>
      <h4>Failure [failure]</h4>
      <strong>Each Failure [failure] cancels one Success [success]. Multiple net Failure [failure] symbols do not influence the magnitude of the failure.</strong>
      <h4>Despair [despair]</h4>
      Despair [despair] counts as one Failure [failure] symbol, in addition to a spectacularly negative consequence that occurs regardless of the task's success or failure."
    }
    
    @rules << {
      :id => "upgradingdice",
      :title => "Upgrading Dice",
      :text => "<p></p>"
    }
    
    @rules << {
      :id => 'downgradingdice',
      :title => 'Downgrading Dice',
      :text => "<p></p>"
    }
    
    @rules << {
      :id => 'buildingdicepool',
      :title => 'Building the Dice Pool',
      :text => "<p></p>"
    }
    
    @rules << {
      :id => "difficulty",
      :title => "Difficulty",
      :text => "<p></p>"
    }
    
    @rules << {
      :id => "characteristics",
      :title => "Characteristics",
      :text => "<p></p>"
    }    

    @rules << {
      :id => "combat",
      :title => "Combat",
      :text => "<p></p>"
    }    
    
  end
end
