class SkillsController < ApplicationController
  def index
    @skills = Skill.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @skills }
    end
  end

  def show
    @skill = Skill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @skill }
    end
  end
end