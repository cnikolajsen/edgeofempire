class GearController < ApplicationController
  def index
    @gear = Gear.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gear }
    end
  end

  def show
    @gear = Gear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gear }
    end
  end
end