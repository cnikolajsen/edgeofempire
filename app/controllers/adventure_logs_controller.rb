class AdventureLogsController < ApplicationController
  before_action :find_character
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  def new
    @adventure_log = AdventureLog.new
  end

  def create
    log_date = nil
    # Lets quickly add a timestamp to the date.
    unless adventure_log_params[:date].blank?
      log_date = "#{adventure_log_params[:date]} #{Time.now.strftime("%I:%M:%S %Z %z")}"
    end
    @log = @character.adventure_logs.create({ date: log_date, log: adventure_log_params[:log], experience: adventure_log_params[:experience], user_id: current_user.id })
    # In case a nil date is submitted set it to log created_at stamp.
    if @log.date.nil?
      @log.update_attribute('date', @log.created_at)
    end
    redirect_to user_character_adventure_logs_url(current_user, @character)
  end

  def update
    @adventure_log = @character.adventure_logs.find(params[:id])
    respond_to do |format|
      if @adventure_log.update(adventure_log_params)
        format.html { redirect_to user_character_adventure_logs_url(current_user, @character), notice:  "Entry was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @adventure_log.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @adventure_log = @character.adventure_logs.find(params[:id])
    @adventure_log.destroy
    redirect_to character_adventure_logs_url(@character)
  end

  def index
    @character_page = 'log'

    @title = "#{@character.name} | Adventure Log"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @character.character_adventure_logs }
      format.xml { render xml: @character.character_adventure_logs }
      #format.pdf do
      #  pdf = CharacterSheetPdf.new(@character, view_context)
      #  send_data pdf.render, filename: "AdventureLog_#{@character.name}-#{@character.created_at.strftime("%d/%m/%Y")}.pdf", type: "application/pdf", disposition: "inline", :margin => 0
      #end
    end

  end

  def edit
    @adventure_log = @character.adventure_logs.find(params[:id])
  end

  private

  def find_character
    character_id = params[:character_id] || params[:id]
    @character = Character.friendly.find(character_id)
  end

  def adventure_log_params
    params.require(:adventure_log).permit(:date, :log, :experience)
  end

  def authenticate_owner
    redirect_to user_character_path(@character.user, @character) unless current_user == @character.user
  end
end
