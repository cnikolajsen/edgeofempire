class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:species, :careers]

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
  end

  def bothan_naming_tables
    @page = 'bothan_names'
    @title = "Bothan Naming Tables"
  end

  def rodian_naming_tables
    @page = 'rodian_names'
    @title = "Rodian Naming Tables"
  end

  def trandoshan_naming_tables
    @page = 'trandoshan_names'
    @title = "Trandoshan Naming Tables"
  end

  def twilek_naming_tables
    @page = 'twilek_names'
    @title = "Twi'lek Naming Tables"
  end

  def droid_naming_tables
    @page = 'droid_names'
    @title = "Droid Naming Tables"
  end

end
