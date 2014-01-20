class SkillsController < ApplicationController
  before_filter :set_up

  def index
    @skills = Skill.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @skills }
    end
  end

  def show
    @skill = Skill.friendly.find(params[:id])
    @title = "#{@skill.name} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @skill }
    end
  end

  def set_up
    @page = 'skills'
    @title = "Skills"
  end

end