class SidebarsController < ApplicationController
  before_filter :set_sidebar
  before_action :set_sidebar, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @sidebars = Sidebar.where(:true).order(:title)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sidebars }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sidebar }
    end
  end

  def new
    @sidebar = Sidebar.new
  end

  def edit
  end

  def create
    @sidebar = Sidebar.new(sidebar_params)

    respond_to do |format|
      if @sidebar.save
        format.html { redirect_to sidebars_path, notice: '#{@sidebar.title} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sidebar }
      else
        format.html { render action: 'new' }
        format.json { render json: @sidebar.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sidebar.update(sidebar_params)
        format.html { redirect_to @sidebar, notice:  "#{@sidebar.title} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sidebar.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sidebar.destroy
    respond_to do |format|
      format.html { redirect_to sidebars_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_sidebar
    @sidebar = Sidebar.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sidebar_params
    params.require(:sidebar).permit(:title, :content)
  end

  def set_page
    @page = 'sidebars'
    @title = 'Sidebars'
  end

end