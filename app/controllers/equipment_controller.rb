class CareersController < ApplicationController
  def index
    @careers = Career.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end

  def show
    @career = Career.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @career }
    end
  end
end