class GearController < ApplicationController
  before_filter :set_up

  def index
    @gear = Gear.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gear }
    end
  end

  def show
    @gear = Gear.find(params[:id])
    @title = "#{@gear.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gear }
    end
  end

  def set_up
    @page = 'gear'
    @title = "Gear"
  end
  
end