# Adversaries controller.
class AdversariesController < InheritedResources::Base
  before_filter :set_adversary
  before_action :set_adversary, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def update

    respond_to do |format|
      if @adversary.update_attributes(adversary_params)
        if !params[:destination].nil?
          if params[:destination] == 'gear'
            message = 'Adversary equipment updated.'
          elsif params[:destination] == 'weapons'
            message = 'Adversary weapons updated.'
          elsif params[:destination] == 'armor'
            message = 'Adversary armor updated.'
          elsif params[:destination] == 'talents'
            message = 'Adversary talents updated.'
          elsif params[:destination] == 'skills'
            message = 'Adversary skill ranks saved.'
          end
          format.html { redirect_to "adversary_#{params[:destination]}".to_sym, notice: message }
        else
          format.html { redirect_to @adversary, notice: 'Adversary was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @adversary.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_adversary
    @adversary = Adversary.friendly.find(params[:id])
  end

  def adversary_params
    params.require(:adversary).permit(
      :name, :description, :brawn, :agility, :intellect, :cunning, :willpower,
      :presence, :soak, :defense_ranged, :defense_melee, :wounds, :strain,
      :race_id, :abilities, :image_url, :book_id, :page, :adversary_type,
      adversary_gears_attributes: [:id, :gear_id, :qty, :gear_model_id, :_destroy],
      adversary_custom_gears_attributes: [:id, :description, :qty, :encumbrance, :_destroy],
      adversary_weapons_attributes: [:id, :weapon_id, :description, :weapon_model_id, :_destroy],
      adversary_obligations_attributes: [:id, :character_id, :obligation_id, :description, :magnitude, :_destroy],
      adversary_skills_attributes: [:id, :character_id, :ranks, :skill_id],
      adversary_armor_attributes: [:id, :armor_id, :description, :armor_model_id, :_destroy],
      adversary_force_powers_attributes: [:id, :force_power_id, :character_id, :_destroy]
    )
  end

  def set_page
    @page = 'adversaries'
  end
end
