class ObligationsController < ApplicationController
  before_filter :set_obligation
  before_action :set_obligation, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @obligations = {}

    @obligations.merge!('Universal' => Obligation.where('career_id IS NULL').order(:name).map { |obl| [obl.id, obl.name, obl.description] })

    Career.where(:true).each do |career|
      @obligations.merge!(career.name => Obligation.where('career_id = ?', career.id).order(:name).map { |obl| [obl.id, obl.name, obl.description] })
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @obligations }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @obligation }
    end
  end

  def new
    @obligation = Obligation.new
  end

  def edit
  end

  def create
    @obligation = Obligation.new(obligation_params)

    respond_to do |format|
      if @obligation.save
        format.html { redirect_to obligations_path, notice: "#{@obligation.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @obligation }
      else
        format.html { render action: 'new' }
        format.json { render json: @obligation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @obligation.update(obligation_params)
        format.html { redirect_to obligations_path, notice:  "#{@obligation.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @obligation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @obligation.destroy
    respond_to do |format|
      format.html { redirect_to obligations_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_obligation
    @obligation = Obligation.find(params[:id])
  end

  def obligation_params
    params.require(:obligation).permit(:name, :description, :career_id)
  end

  def set_page
    @page = 'obligations'
  end
end
