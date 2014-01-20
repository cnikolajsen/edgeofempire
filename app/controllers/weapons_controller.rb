class WeaponsController < ApplicationController
  before_filter :set_up

  def index
    @weapons = Weapon.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @weapons }
    end
  end

  def show
    @weapon = Weapon.friendly.find(params[:id])
    @title = "#{@weapon.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @weapon }
    end
  end

  def set_up
    @page = 'weapons'
    @title = "Weapons"
  end

end