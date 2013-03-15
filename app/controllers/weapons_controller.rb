class WeaponsController < ApplicationController
  def index
    @weapons = Weapon.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @weapons }
    end
  end

  def show
    @weapons = Weapon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @weapons }
    end
  end
end