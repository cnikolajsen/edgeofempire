class TalentTreesController < ApplicationController
  before_filter :set_talent_tree
  before_action :set_talent_tree, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @talent_trees = TalentTree.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @talent_trees }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @talent_tree }
    end
  end

  def new
    @talent_tree = TalentTree.new
  end

  def edit
  end

  def create
    @talent_tree = TalentTree.new(talent_tree_params)

    respond_to do |format|
      if @talent_tree.save
        format.html { redirect_to talent_trees_path, notice: '#{@talent_tree.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @talent_tree }
      else
        format.html { render action: 'new' }
        format.json { render json: @talent_tree.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @talent_tree.update(talent_tree_params)
        format.html { redirect_to talent_tree_path(@talent_tree), notice:  "#{@talent_tree.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @talent_tree.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @talent_tree.destroy
    respond_to do |format|
      format.html { redirect_to talent_trees_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_talent_tree
    @talent_tree = TalentTree.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def talent_tree_params
    params.require(:talent_tree).permit(:description, :name, :career_id, :talent_1_1, :talent_1_2, :talent_1_3, :talent_1_4, :talent_2_1, :talent_2_2, :talent_2_3, :talent_2_4, :talent_3_1, :talent_3_2, :talent_3_3, :talent_3_3, :talent_3_4, :talent_4_1, :talent_4_2, :talent_4_3, :talent_4_4, :talent_4_4, :talent_2_1_require_1_1, :talent_2_1_require_2_2, :talent_2_2_require_1_2, :talent_2_2_require_2_3, :talent_2_3_require_1_3, :talent_2_3_require_2_4, :talent_2_4_require_1_4, :talent_3_1_require_2_1, :talent_3_1_require_3_2, :talent_3_2_require_2_2, :talent_3_2_require_3_3, :talent_3_3_require_2_3, :talent_3_3_require_3_4, :talent_3_4_require_2_4, :talent_4_1_require_3_1, :talent_4_1_require_4_2, :talent_4_2_require_3_2, :talent_4_2_require_4_3, :talent_4_3_require_3_3, :talent_4_3_require_4_4, :talent_4_4_require_3_4, :talent_5_1, :talent_5_1_require_4_1, :talent_5_1_require_5_2, :talent_5_2, :talent_5_2_require_4_2, :talent_5_2_require_5_3, :talent_5_3, :talent_5_3_require_4_3, :talent_5_3_require_5_4, :talent_5_4, :talent_5_4_require_4_4,
    talent_tree_career_skills_attributes: [ :id, :skill_id, :talent_tree_id ])
  end

  def set_page
    @top_page = 'careers'
    @page = 'talent_trees'
  end

end