class ObligationsController < ApplicationController
  before_filter :set_up

  def index
    @obligations = Obligation.where(:true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @obligations }
    end
  end

  def set_up
    @page = 'obligations'
    @title = "Obligations"
  end
end
