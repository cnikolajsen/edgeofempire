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

end
