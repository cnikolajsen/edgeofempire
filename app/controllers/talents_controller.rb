class TalentsController < ApplicationController
  before_filter :set_talent
  before_action :set_talent, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @talents = Talent.where(:true).order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @talents }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @talent }
    end
  end

  def new
    @talent = Talent.new
  end

  def edit
  end

  def create
    @talent = Talent.new(talent_params)

    respond_to do |format|
      if @talent.save
        format.html { redirect_to talents_path, notice: '#{@talent.name} was successfully created.' }
        format.json { render action: 'show', status: :created, location: @talent }
      else
        format.html { render action: 'new' }
        format.json { render json: @talent.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @talent.update(talent_params)
        format.html { redirect_to talents_path, notice:  "#{@talent.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @talent.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @talent.destroy
    respond_to do |format|
      format.html { redirect_to talents_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_talent
    @talent = Talent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def talent_params
    params.require(:talent).permit(:name, :description, :activation, :ranked)
  end

  def set_page
    @page = 'talents'
  end

end