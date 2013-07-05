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
    @page = 'rodian_names'
    @title = "Rodian Naming Tables"
    @partial_name = 'rodian_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""
  end

  def trandoshan_naming_tables
    @page = 'trandoshan_names'
    @title = "Trandoshan Naming Tables"
    @partial_name = 'trandoshan_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""
  end

  def twilek_naming_tables
    @page = 'twilek_names'
    @title = "Twi'lek Naming Tables"
    @partial_name = 'twilek_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""
  end

  def droid_naming_tables
    @page = 'droid_names'
    @title = "Droid Naming Tables"
    @partial_name = 'droid_naming_tables'
    @description = Hash.new()
    @description = []
    @step_one = ""
  end

end
