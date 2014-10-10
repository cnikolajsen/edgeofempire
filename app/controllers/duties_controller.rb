class DutiesController < InheritedResources::Base
  before_filter :set_duty
  before_action :set_duty, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @duties = {}

    @duties.merge!('Universal' => Duty.where('career_id IS NULL').order(:name).map { |duty| [duty.id, duty.name, duty.description] })

    Career.where(:true).each do |career|
      @duties.merge!(career.name => Duty.where('career_id = ?', career.id).order(:name).map { |duty| [duty.id, duty.name, duty.description] })
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @duties }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @duty }
    end
  end

  def new
    @duty = Duty.new
  end

  def edit
  end

  def create
    @duty = Duty.new(duty_params)

    respond_to do |format|
      if @duty.save
        format.html { redirect_to duties_path, notice: "#{@duty.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @duty }
      else
        format.html { render action: 'new' }
        format.json { render json: @duty.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @duty.update(duty_params)
        format.html { redirect_to duties_path, notice:  "#{@duty.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @duty.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @duty.destroy
    respond_to do |format|
      format.html { redirect_to duties_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_duty
    @duty = Duty.find(params[:id])
  end

  def duty_params
    params.require(:duty).permit(:name, :description, :career_id)
  end

  def set_page
    @page = 'duties'
  end
end
