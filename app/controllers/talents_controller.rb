class TalentsController < ApplicationController
  before_filter :set_up

  def index
    @talents = Talent.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @talents }
    end
  end

  def set_up
    @page = 'talents'
    @title = "Talents"
  end
end
