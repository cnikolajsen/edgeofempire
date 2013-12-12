class RacesController < ApplicationController
  before_filter :set_up

  def index
    @races = Race.where(:true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @races }
    end
  end

  def show
    @race = Race.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @race }
    end
  end

  def set_up
    @page = 'races'
    @title = "Races"
  end

end