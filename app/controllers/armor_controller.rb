class ArmorController < ApplicationController
  def index
    @armor = Armor.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @armor }
    end
  end

  def show
    @armor = Armor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @armor }
    end
  end
end