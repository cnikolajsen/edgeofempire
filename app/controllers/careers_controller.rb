class CareersController < ApplicationController
  before_filter :set_career
  before_action :set_career, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @careers = Career.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @careers }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @career }
    end
  end

    def new
      @career = Career.new
    end

    def edit
    end

    def create
      @career = Career.new(career_params)

      respond_to do |format|
        if @career.save
          format.html { redirect_to careers_path, notice: '#{@career.name} was successfully created.' }
          format.json { render action: 'show', status: :created, location: @career }
        else
          format.html { render action: 'new' }
          format.json { render json: @career.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @career.update(career_params)
          format.html { redirect_to careers_path, notice:  "#{@career.name} was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @career.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @career.destroy
      respond_to do |format|
        format.html { redirect_to careers_url }
        format.json { head :no_content }
      end
    end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_career
    @career = Career.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def career_params
    params.require(:career).permit(:name, :description, :image_url,
    career_skills_attributes: [ :id, :career_id, :skill_id, :_destroy ])

  end

  def set_page
    @top_page = 'careers'
    @page = 'careers'
  end

end