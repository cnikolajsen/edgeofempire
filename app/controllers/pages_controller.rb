class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:species, :careers]

  def home
    @page = 'home'
    @title = "Edge of the Empire Dummy Frontpage"
  end

  def species
    @species = Race.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @species }
    end
  end

  def careers
    @careers = Career.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end


end
