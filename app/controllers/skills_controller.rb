class SkillsController < ApplicationController
  before_filter :set_skill
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @skills = Skill.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @skills }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @skill }
    end
  end

  def new
    @skill = Skill.new
  end

  def edit
  end

  def create
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to skills_path, notice: '#{@skill.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @skill }
      else
        format.html { render action: 'new' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @skill.update(skill_params)
        format.html { redirect_to skill_path(@skill), notice:  "#{@skill.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @skill.destroy
    respond_to do |format|
      format.html { redirect_to skills_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_skill
    @skill = Skill.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def skill_params
    params.require(:skill).permit(:description, :name, :characteristic)

  end

  def set_page
    @top_page = 'careers'
    @page = 'skills'
  end

end