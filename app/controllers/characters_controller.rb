class CharactersController < ApplicationController
  include TalentsHelper
  include RacesHelper
  include CharactersHelper

  before_action :find_character, except: [:index]
  before_filter :set_up
  before_filter :authenticate_user!, :except =>:show

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.where(:user_id => current_user.id).includes(:race).includes(:career)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @characters }
    end
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    @character_page = 'view'

    @title = "#{@character.name} | #{@title}"
    @character_state = character_state(@character)

    # Determine characteristic increases from talents.
    @character.talent_alterations.each do |talent_id, stat|
      stat.each do |type, value|
        if type == :on_purchase && value[:type] == :select_characteristic
          if @character.talents[talent_id]['options'].include?('Brawn') && @character.brawn < 6
            @character.brawn += 1
          end
          if @character.talents[talent_id]['options'].include?('Agility') && @character.agility < 6
            @character.agility += 1
          end
          if @character.talents[talent_id]['options'].include?('Cunning') && @character.cunning < 6
            @character.cunning += 1
          end
          if @character.talents[talent_id]['options'].include?('Intellect') && @character.intellect < 6
            @character.intellect += 1
          end
          if @character.talents[talent_id]['options'].include?('Presence') && @character.presence < 6
            @character.presence += 1
          end
          if @character.talents[talent_id]['options'].include?('Willpower') && @character.willpower < 6
            @character.willpower += 1
          end
        end
      end
    end

    # Determine characteristic increases from cybernetics.
    if @character.cybernetics[:items].any?
      @character.cybernetics[:bonuses].each do |cb|
        if cb[0] == :brawn && @character.brawn < 6
          @character.brawn += cb[1]
        end
        if cb[0] == :agility && @character.agility < 6
          @character.agility += cb[1]
        end
        if cb[0] == :cunning && @character.cunning < 6
          @character.cunning += cb[1]
        end
        if cb[0] == :intellect && @character.intellect < 6
          @character.intellect += cb[1]
        end
        if cb[0] == :presence && @character.presence < 6
          @character.presence += cb[1]
        end
        if cb[0] == :willpower && @character.willpower < 6
          @character.willpower += cb[1]
        end
      end
    end

    # Increase characteristics that don't affect derived stats.
    # I.e armor attachments increasing brawn.
    unless @character.armor_modification_bonuses['characteristics'].blank?
      @character.armor_modification_bonuses['characteristics'].each do |stat|
        unless stat.blank?
          @character[stat] += 1
        end
      end
    end

    # Apply species special abilities.
    race_alterations = {}
    unless @character.race.nil?
      if respond_to?("special_ability_#{@character.race.name.gsub(' ', '').gsub("'", "").downcase}")
        race_alterations = {}
        race_alterations = send("special_ability_#{@character.race.name.gsub(' ', '').gsub("'", "").downcase}")
      end
    end

    error_messages = ''
    # Show error messages if some combination of species and career/specialization free ranks go above 2 during character creation.
    if @character.creation?
      @character.character_skills.each do |character_skill|
        if character_skill.ranks > 2
          error_messages += "<i class='fi-dislike'> You have more than the allowed <strong>2 ranks</strong> at character creation in the skill <strong>#{character_skill.skill.name}</strong>. Check your free bonus ranks from either species, career, or specialization.</i><br />"
        end
      end
    end

    # Validate free ranks from career selection.
    career_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').each do |career_skill|
      career_free_rank << career_skill.skill_id
    end

    if !@character.career.nil? and !@character.race.nil? and @character.race.name == 'Droid'
      career_free_rank_max_count = 6
    else
      career_free_rank_max_count = 4
    end

    if career_free_rank.count > career_free_rank_max_count
      error_messages += "<i class='fi-dislike'> You have selected too many career skills to place a free rank in. The #{@character.race.name} species allows you to choose <strong>#{career_free_rank_max_count} skills</strong>, but you have chosen <strong>#{career_free_rank.count} skills</strong>.</i><br />"
    end

    unless error_messages.blank?
      flash.now[:error] = error_messages
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @character, :methods => [:soak, :defense, :strain_threshold, :wound_threshold, :attacks, :encumbrance_threshold, :inventory, :talents, :specializations, :force_rating] }
      format.pdf do
        pdf = CharacterSheetPdf.new(@character, view_context)
        send_data pdf.render, filename: "Character_Sheet_#{@character.name}-#{@character.created_at.strftime("%d/%m/%Y")}.pdf", type: "application/pdf", disposition: "inline", :margin => 0
      end
    end
  end

  # GET /characters/new
  # GET /characters/new.json
  def new
    @character = Character.new
    @title = "New Character"
    @page = 'new_character'

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /characters/1/edit
  def edit
    @character_state = character_state(@character)

    @title = "#{@character.name} | Edit"
    @character_page = 'basics'
    @character_menu = 'basics'
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(character_params)
    @character.user_id = current_user.id
    @character.credits = 500

    respond_to do |format|
      if @character.save
        Skill.where(true).each do |skill|
          @character_skill = CharacterSkill.new()
          @character_skill.character_id = @character.id
          @character_skill.ranks = 0
          @character_skill.free_ranks_career = 0
          @character_skill.free_ranks_specialization = 0
          @character_skill.free_ranks_race = 0
          @character_skill.free_ranks_equipment = 0
          @character_skill.skill_id = skill.id

          @character_skill.save
        end

        species = Race.find(@character.race_id)

        # Save subspecies.
        if params[:sub_species]
          if species.respond_to?("#{species.name.gsub(' ', '').downcase}_traits")
            traits = species.send("#{species.name.gsub(' ', '').downcase}_traits")
            if traits[:sub_species][params[:sub_species]]
              # Add experience entry in the adventure log for species bonus XP.
              CharacterAdventureLog.where(:character_id => @character.id, :experience => traits[:sub_species][params[:sub_species]][:exp_bonus], :date => @character.created_at, :log => "Subspecies bonus experience").create
              @character.update_attribute(:subspecies, params[:sub_species])
            end
          end
        end

        # Save selectable free species skill ranks.
        if params[:skill_rank_choice]
          @character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => params[:skill_rank_choice]).first
          if @character_skill
            @character_skill.free_ranks_race = 1
            @character_skill.save

            # Save experience entry.
            set_experience_cost(@character.id, 'skill', params[:skill_rank_choice], 1, 'up', 'race')
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => params[:skill_rank_choice], :granted_by => 'race', :ranks => 1).first_or_create
          end
        end

        format.html { redirect_to character_url(@character), notice: 'Character was successfully created.' }
        format.json { render json: @character, status: :created, location: @character }
      else
        format.html { render action: "new" }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /characters/1
  # PUT /characters/1.json
  def update
    if @character.aasm_state.nil?
      @character.aasm_state = 'creation'
    end

    # Remove equipment with 0 quantity.
    if !@character.character_gears.nil?
      @character.character_gears.each do |cg|
        if cg.qty.nil? || cg.qty < 1
          @item = CharacterGear.find_by_id(cg.id)
          @item.destroy
        end
      end
    end

    if params[:update_specializations]
      if params[:character][:specialization_1] && !params[:character][:specialization_1].blank?
        set_experience_cost(@character.id, 'specialization', params[:character][:specialization_1], 1, direction = 'up')
      end
      if params[:character][:specialization_2] && !params[:character][:specialization_2].blank?
        set_experience_cost(@character.id, 'specialization', params[:character][:specialization_2], 2, direction = 'up')
      end
      if params[:character][:specialization_3] && !params[:character][:specialization_3].blank?
        set_experience_cost(@character.id, 'specialization', params[:character][:specialization_3], 3, direction = 'up')
      end
    end

    # Update talents.
    if !params[:update_talents].nil?
      @talent_trees = Array.new
      unless @character.specialization_1.nil?
        @talent_trees << TalentTree.find_by_id(@character.specialization_1)
      end
      unless @character.specialization_2.nil?
        @talent_trees << TalentTree.find_by_id(@character.specialization_2)
      end
      unless @character.specialization_3.nil?
        @talent_trees << TalentTree.find_by_id(@character.specialization_3)
      end
    end

    # Update character skill entries for character to add in new skills created since the character was created.
    existing_skills = Array.new
    @character.character_skills.each do |skill|
      existing_skills << skill.skill.id unless skill.skill.nil?
    end
    Skill.where(true).each do |skill|
      if !existing_skills.include?(skill.id)
        @character_skill = CharacterSkill.new()
        @character_skill.character_id = @character.id
        @character_skill.ranks = 0
        @character_skill.skill_id = skill.id
        @character_skill.save
      end
    end

    if !params[:character_characteristics].nil?
      ['brawn', 'agility', 'intellect', 'willpower', 'cunning', 'presence'].each do |stat|
        if params[:character][stat.to_sym].to_i > @character.race[stat]
          set_experience_cost(@character.id, stat, 0, params[:character][stat.to_sym].to_i, 'up')
        elsif params[:character][stat.to_sym].to_i < @character[stat]
          set_experience_cost(@character.id, stat, 0, (@character[stat] - params[:character][stat.to_sym].to_i), 'down')
        end
      end
    end

    respond_to do |format|
      if @character.update_attributes(character_params)
        if !params[:destination].nil?
          if params[:destination] == 'gear'
            message = 'Character equipment updated.'
          elsif params[:destination] == 'weapons'
            message = 'Character weapons updated.'
          elsif params[:destination] == 'armor'
            message = 'Character armor updated.'
          elsif params[:destination] == 'talents'
            message = 'Character talents updated.'
          elsif params[:destination] == 'skills'
            message = 'Character career free skill ranks saved.'
          elsif params[:destination] == 'characteristics'
            message = 'Character characteristics saved.'
          elsif params[:destination] == 'background'
            message = 'Character background saved.'
          elsif params[:destination] == 'obligation'
            message = 'Character obligation saved.'
          elsif params[:destination] == 'motivation'
            message = 'Character motivation saved.'
          end
          format.html { redirect_to "character_#{params[:destination]}".to_sym, notice: message }
        else
          format.html { redirect_to @character, notice: 'Character was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    @character.destroy

    respond_to do |format|
      format.html { redirect_to characters_url, notice: 'Character was successfully deleted.'  }
      format.json { head :no_content }
    end
  end

  def talents
    @character_page = 'talents'
    @character_state = character_state(@character)
    @title = "#{@character.name} | Talents"

    @talent_trees = Array.new
    unless @character.specialization_1.nil?
      @talent_trees << TalentTree.find_by_id(@character.specialization_1)

      @specialization_free_rank = Array.new()
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').each do |career_skill|
        @specialization_free_rank << career_skill.skill_id
      end
    end
    unless @character.specialization_2.nil?
      @talent_trees << TalentTree.find_by_id(@character.specialization_2)
    end
    unless @character.specialization_3.nil?
      @talent_trees << TalentTree.find_by_id(@character.specialization_3)
    end
  end

  def career_selection
    @career = Career.find(params[:career_id])

    render :partial => "career_info", :locals => { :career => @career, :changed => :true }
  end

  def species_selection
    @species = Race.find(params[:species_id])

    render :partial => "species_info", :locals => { :species => @species, :character => @character, :changed => :true }
  end

  def characteristics
    @character_menu = 'basics'
    @character_page = 'characteristics'
    @title = "#{@character.name} | Characteristics"
    @character_state = character_state(@character)
  end

  def background
    @character_menu = 'basics'
    @character_page = 'background'
    @title = "#{@character.name} | Background"
    @character_state = character_state(@character)
  end

  def set_activate
    @character.activate
    @character.save
    redirect_to @character, notice: 'Character activated. Character creation rules no longer apply.'
  end

  def set_retired
    @character.retire
    @character.save
    redirect_to @character, notice: 'Character taken off duty. Character is now read only.'
  end

  def set_creation
    @character.set_create
    @character.save
    redirect_to @character, notice: 'Character put into creation mode. Special rules apply.'
  end

  private

  def find_character
    if params[:id]
      @character = Character.friendly.find(params[:id])
    end
  end

  def set_up
    @page = 'characters'
    @character_page = 'basics'
    @title = "Characters"
  end

  def character_params
    params.require(:character).permit(
      :age,
      :agility,
      :brawn,
      :career_id,
      :cunning,
      :gender,
      :intellect,
      :name,
      :presence,
      :race_id,
      :subspecies,
      :willpower,
      :experience,
      :credits,
      :bio,
      :height,
      :build,
      :hair,
      :eyes,
      :notable_features,
      :other,
      :specialization_1,
      :specialization_2,
      :specialization_3,
      character_gears_attributes: [ :id, :gear_id, :qty, :carried, :gear_model_id, :_destroy ],
      character_custom_gears_attributes: [ :id, :description, :qty, :carried, :encumbrance, :_destroy ],
      character_weapons_attributes: [ :id, :weapon_id, :description, :equipped, :carried, :weapon_model_id, :_destroy ],
      character_obligations_attributes: [ :id, :character_id, :obligation_id, :description, :magnitude, :_destroy ],
      character_skills_attributes: [ :id, :character_id, :ranks, :skill_id ],
      character_armor_attributes: [ :id, :armor_id, :description, :equipped, :carried, :armor_model_id, :_destroy ],
      character_force_powers_attributes: [ :id, :force_power_id, :character_id, :_destroy ],
    )
  end
end
