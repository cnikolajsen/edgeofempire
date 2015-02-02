class MotivationsController < ApplicationController
  before_filter :set_motivation
  before_action :set_motivation, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @motivations = {}

    @motivations.merge!('Universal' => Motivation.where('career_id IS NULL').order(:name).map { |obl| [obl.id, obl.name, obl.description] })

    Career.where(:true).each do |career|
      @motivations.merge!(career.name => Motivation.where('career_id = ?', career.id).order(:name).map { |obl| [obl.id, obl.name, obl.description] })
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @motivations }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @motivation }
    end
  end

  def new
    @motivation = Motivation.new
  end

  def edit
  end

  def create
    @motivation = Motivation.new(motivation_params)

    respond_to do |format|
      if @motivation.save
        format.html { redirect_to motivations_path, notice: "#{@motivation.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @motivation }
      else
        format.html { render action: 'new' }
        format.json { render json: @motivation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @motivation.update(motivation_params)
        format.html { redirect_to motivations_path, notice:  "#{@motivation.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @motivation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @motivation.destroy
    respond_to do |format|
      format.html { redirect_to motivations_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_motivation
    @motivation = Motivation.find(params[:id])
  end

  def motivation_params
    params.require(:motivation).permit(:name, :description, :career_id)
  end

  def set_page
    @page = 'motivations'
  end
end
