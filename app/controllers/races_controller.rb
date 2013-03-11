class RacesController < ApplicationController
  def index
    @races = Race.find(:all, :order => :name)

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
end