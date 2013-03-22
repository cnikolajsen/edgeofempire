class CareersController < ApplicationController
  before_filter :set_up

  def index
    @careers = Career.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end

  def show
    @career = Career.find(params[:id])
    @title = "#{@career.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @career }
    end
  end

  def set_up
    @page = 'careers'
    @title = "Carerrs"
  end
  
end