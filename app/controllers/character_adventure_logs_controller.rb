class CharacterAdventureLogsController < ApplicationController
  before_action :find_character

  def create
    @log = @character.character_adventure_logs.create(character_adventure_log_params)
    if @log.date.nil?
      @log.update_attribute('date', @log.created_at)
    end
    redirect_to log_url(@character)
  end

  def destroy
    @log = @character.character_adventure_logs.find(params[:id])
    @log.destroy
    redirect_to log_url(@character)
  end

  def show

  end

  private
    def find_character
      character_id = params[:character_id] || params[:id]
      @character = Character.friendly.find(character_id)
    end

    def character_adventure_log_params
      params.require(:character_adventure_log).permit(:date, :log, :experience)
    end
end
