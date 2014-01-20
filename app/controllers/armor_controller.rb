class ArmorController < ApplicationController
  before_filter :set_up

  def index
    @armor = Armor.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @armor }
    end
  end

  def show
    @armor = Armor.friendly.find(params[:id])
    @title = "#{@armor.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @armor }
    end
  end

  def set_up
    @page = 'armor'
    @title = "Armor"
  end

  private

  def armor_params
    params.require(:armor).permit( :defense, :description, :name, :price, :soak )
  end
end