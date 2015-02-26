# Rules controller.
class RulesController < ApplicationController
  before_filter :set_rule
  before_action :set_rule, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @rules = Rule.where(:true).order(:title)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rules }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rule }
    end
  end

  def new
    @rule = Rule.new
  end

  def edit
  end

  def create
    @rule = Rule.new(rule_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to rules_path, notice: "#{@rule.title} was successfully created." }
        format.json { render action: 'show', status: :created, location: @rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @rule.update(rule_params)
        format.html { redirect_to @rule, notice:  "#{@rule.title} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rule.destroy
    respond_to do |format|
      format.html { redirect_to rules_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rule
    @rule = Rule.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rule_params
    params.require(:rule).permit(:title, :content)
  end

  def set_page
    @page = 'rules'
    @title = 'Rules'
    @parent_page = 'misc'
  end
end
