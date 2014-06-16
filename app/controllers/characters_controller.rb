class CharactersController < ApplicationController
  include TalentsHelper
  include RacesHelper
  include CharactersHelper

  before_filter :set_up
  before_filter :authenticate_user!, :except =>:show

  before_action :find_character, :only => [:show, :edit, :update, :destroy,
    :skills, :character_skill_rank_up, :character_skill_rank_down, :talents,
    :untrain_specialization, :career, :species, :characteristics, :background,
    :obligation, :add_obligation, :motivation, :add_motivation, :armor,
    :armor_attachment, :add_armor_attachment_option, :remove_armor_attachment_option,
    :weapons, :weapon_attachment, :add_weapon_attachment_option,
    :remove_weapon_attachment_option, :equipment, :add_equipment,
    :remove_equipment, :place_equipment, :force_powers, :add_force_power,
    :remove_force_power, :add_force_power_upgrade, :remove_force_power_upgrade,
    :set_activate, :set_retired, :set_creation]

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.where(:user_id => current_user.id)

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
      format.json { render json: @character }
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
    @character.experience = 0

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

        # Save species characteristics.
        ['brawn', 'agility', 'intellect', 'willpower', 'cunning', 'presence'].each do |stat|
          @character.update_attribute(stat.to_sym, species[stat])
          # Save experience entries for species characteristics.
          set_experience_cost(stat, 0, species[stat], 'up', 'race')
        end

        # Save subspecies.
        if params[:sub_species]
          if species.respond_to?("#{species.name.gsub(' ', '').downcase}_traits")
            traits = species.send("#{species.name.gsub(' ', '').downcase}_traits")
            if traits[:sub_species][params[:sub_species]]
              @character.update_attribute(:experience, traits[:sub_species][params[:sub_species]][:exp_bonus])
              @character.update_attribute(:subspecies, params[:sub_species])
            end
          end
        end

        # Save species talents.
        unless species.talents.nil?
          species.talents.each do |talent|
            character_bonus_talent = CharacterBonusTalent.new()
            character_bonus_talent.character_id = @character.id
            character_bonus_talent.talent_id = talent.id
            character_bonus_talent.bonus_type = 'racial'
            character_bonus_talent.save

            # Save experience entry.
            set_experience_cost('talent', talent.id, 1, 'up', 'race')
          end
        end

        # Save fixed free species skill ranks.
        RaceSkill.where(:race_id => species.id).each do |race_skill|
          @character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => race_skill.skill_id).first
          unless @character_skill.nil?
            @character_skill.free_ranks_race = race_skill.ranks
            @character_skill.save

            # Save experience entry.
            race_skill.ranks.times do |rank|
              set_experience_cost('skill', race_skill.skill_id, rank + 1, 'up', 'race')
            end
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => race_skill.id, :granted_by => 'race', :ranks => race_skill.ranks).first_or_create
          end
        end
        # Save selectable free species skill ranks.
        if params[:skill_rank_choice]
          @character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => params[:skill_rank_choice]).first
          if @character_skill
            @character_skill.free_ranks_race = 1
            @character_skill.save

            # Save experience entry.
            set_experience_cost('skill', params[:skill_rank_choice], 1, 'up', 'race')
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => params[:skill_rank_choice], :granted_by => 'race', :ranks => 1).first_or_create
          end
        end

        # Save a weapon entry for unarmed combat.
        unarmed_weapon = Weapon.where(:name => 'Unarmed').first
        character_unarmed = CharacterWeapon.where(:character_id => @character.id, :weapon_id => unarmed_weapon.id).first_or_create
        character_unarmed = CharacterWeapon.new()
        character_unarmed.character_id = @character.id
        character_unarmed.weapon_id = unarmed_weapon.id
        character_unarmed.carried = true
        character_unarmed.equipped = true
        character_unarmed.save

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
      if params[:character][:specialization_1]
        set_experience_cost('specialization', params[:character][:specialization_1], 1, direction = 'up')
      end
      if params[:character][:specialization_2]
        set_experience_cost('specialization', params[:character][:specialization_2], 2, direction = 'up')
      end
      if params[:character][:specialization_3]
        set_experience_cost('specialization', params[:character][:specialization_3], 3, direction = 'up')
      end
    end

    if params[:free_skill_ranks]
      # Save specialization skills to add a free rank to.
      if params[:free_specialization_skill_rank]
        specialization_skills = TalentTree.find_by_id(@character.specialization_1).skills
        specialization_skills.each do |skill|
          if params[:free_specialization_skill_rank].include? skill.id.to_s
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'specialization', :ranks => 1).first_or_create
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            if character_skill.free_ranks_specialization == 0 or character_skill.free_ranks_specialization.blank?
              character_skill.free_ranks_specialization = 1
              character_skill.save
            end

            # Check if this skill already has an entry from specialization.
            if get_experience_cost('skill', skill.id, 'specialization').blank?
              # Save experience entry.
              experience_cost = get_experience_cost('skill', skill.id)
              if experience_cost.nil? or experience_cost.blank?
                set_experience_cost('skill', skill.id, 1, 'up', 'specialization')
              else
                set_experience_cost('skill', skill.id, experience_cost.last.rank + 1, 'up', 'specialization')
              end
            end
          else
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'specialization').delete_all
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            unless character_skill.free_ranks_specialization.blank? or character_skill.free_ranks_specialization == 0
              character_skill.free_ranks_specialization -= 1
              character_skill.save
            end

            # Delete experience entry.
            get_experience_cost('skill', skill.id, 'specialization').delete_all
          end
        end
      end

      # Save career skills to add a free rank to.
      if params[:free_career_skill_rank]
        @character.career.skills.each do |skill|
          if params[:free_career_skill_rank].include? skill.id.to_s
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'career', :ranks => 1).first_or_create
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            if character_skill.free_ranks_career == 0 or character_skill.free_ranks_career.blank?
              character_skill.free_ranks_career = 1
              character_skill.save
            end

            # Check if this skill already has an entry from specialization.
            if get_experience_cost('skill', skill.id, 'career').blank?
              # Save experience entry.
              experience_cost = get_experience_cost('skill', skill.id)
              if experience_cost.nil? or experience_cost.blank?
                set_experience_cost('skill', skill.id, 1, 'up', 'career')
              else
                set_experience_cost('skill', skill.id, experience_cost.last.rank + 1, 'up', 'career')
              end
            end
          else
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'career').delete_all
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            unless character_skill.free_ranks_career.blank? or character_skill.free_ranks_career == 0
              character_skill.free_ranks_career -= 1
              character_skill.save
            end

            # Delete experience entry.
            get_experience_cost('skill', skill.id, 'career').delete_all
          end
        end
      end

      # Save non career skills to add a free rank to. Mainly from racial traits.
      if params[:free_non_career_skill_rank]
        @character.career.non_career_skills.each do |skill|
          if params[:free_non_career_skill_rank].include? skill.id.to_s
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'racial_trait', :ranks => 1).first_or_create
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            if character_skill.free_ranks_race == 0 or character_skill.free_ranks_race.blank?
              character_skill.free_ranks_race = 1
              character_skill.save
            end

            # Check if this skill already has an entry from specialization.
            if get_experience_cost('skill', skill.id, 'racial_trait').blank?
              # Save experience entry.
              experience_cost = get_experience_cost('skill', skill.id)
              if experience_cost.nil? or experience_cost.blank?
                set_experience_cost('skill', skill.id, 1, 'up', 'racial_trait')
              else
                set_experience_cost('skill', skill.id, experience_cost.last.rank + 1, 'up', 'racial_trait')
              end
            end
          else
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'racial_trait').delete_all
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            unless character_skill.free_ranks_race.blank? or character_skill.free_ranks_race == 0
              character_skill.free_ranks_race -= 1
              character_skill.save
            end

            # Delete experience entry.
            get_experience_cost('skill', skill.id, 'racial_trait').delete_all
          end
        end
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

      @talent_trees.each do |tree|
        @character_talent_tree = CharacterTalent.where(:character_id => @character.id, :talent_tree_id => tree.id).first_or_create
        if @character_talent_tree.id.nil?
          @character_talent_tree.character_id = @character.id
          @character_talent_tree.talent_tree_id = tree.id
        end

        # Save data for 5 rows with 4 columns.
        5.times do |r_key|
          4.times do |c_key|
            if !params["tree_#{tree.id}-talent_#{r_key + 1 }_#{c_key + 1}"].nil?
              @character_talent_tree["talent_#{r_key + 1}_#{c_key + 1}"] = tree["talent_#{r_key + 1}_#{c_key + 1}"]
              talent_options = Array.new
              3.times do |o_key|
                unless params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key +1}-option_#{o_key}"].nil?
                  talent_options << params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key + 1}-option_#{o_key}"] unless params["tree_#{tree.id}-talent_#{r_key + 1}_#{c_key + 1}-option_#{o_key}"].empty?
                end
              end
              @character_talent_tree["talent_#{r_key + 1}_#{c_key + 1}_options"] = talent_options
              # Save experience entry.
              set_experience_cost('talent', params["tree_#{tree.id}-talent_#{r_key + 1 }_#{c_key + 1}"], r_key + 1, 'up', nil)
            else
              @character_talent_tree["talent_#{r_key + 1}_#{c_key + 1}"] = nil
              # Save experience entry.
              set_experience_cost('talent', tree["talent_#{r_key + 1}_#{c_key + 1}"], r_key + 1, 'down', nil)
            end
          end
        end

        @character_talent_tree.save
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
          set_experience_cost(stat, 0, params[:character][stat.to_sym].to_i, 'up')
        elsif params[:character][stat.to_sym].to_i < @character[stat]
          set_experience_cost(stat, 0, (@character[stat] - params[:character][stat.to_sym].to_i), 'down')
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

  def skills
    @character_page = 'skills'
    @title = "#{@character.name} | Skills"
    @character_state = character_state(@character)
    @skill_state = skill_state(@character)

    @skill_select_enabled = true
    @character_state.each do |state|
      if state['state_short'] == "missing_free_skills"
        @skill_select_enabled = false
      end
    end
    free_skill_ranks
  end

  def free_skill_ranks
    @career_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').each do |career_skill|
      @career_free_rank << career_skill.skill_id
    end
    @racial_trait_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'racial_trait').each do |non_career_skill|
      @racial_trait_free_rank << non_career_skill.skill_id
    end

    @initial_talent_tree = nil
    if @character.specialization_1
      @initial_talent_tree = TalentTree.find_by_id(@character.specialization_1)

      @specialization_free_rank = Array.new()
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').each do |career_skill|
        @specialization_free_rank << career_skill.skill_id
      end
    end
  end

  def character_skill_rank_up
    character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => params[:skill_id]).first
    character_skill.ranks += 1
    character_skill.save

    set_experience_cost('skill', character_skill.skill_id, skill_total_ranks(character_skill), 'up')

    @skill = Skill.find(params[:skill_id])
    @skill_select_enabled = true
    free_skill_ranks
    flash[:success] = "#{@skill.name} rank increased"

    respond_to do |format|
      format.js  {}
    end
  end

  def character_skill_rank_down
    character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => params[:skill_id]).first
    set_experience_cost('skill', character_skill.skill_id, skill_total_ranks(character_skill), 'down')
    character_skill.ranks -= 1 unless character_skill.ranks == 0
    character_skill.save

    @skill = Skill.find(params[:skill_id])
    @skill_select_enabled = true
    free_skill_ranks
    flash[:success] = "#{@skill.name} rank decreased"

    respond_to do |format|
      format.js  {}
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

  def untrain_specialization
    specialization = TalentTree.find(params[:spec_id])
    set_experience_cost('specialization', specialization.id, params[:spec_num], direction = 'down')
    @character["specialization_#{params[:spec_num]}".to_sym] = nil
    @character.save
    CharacterTalent.where(:character_id => @character.id, :talent_tree_id => params[:spec_id]).delete_all
    if params[:spec_num].to_i == 1
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').delete_all
      CharacterExperienceCost.where(:character_id => @character.id, :resource_type => 'skill', :granted_by => 'specialization').delete_all
    end
    redirect_to character_talents_url(:id => @character.id), notice: "#{@character.name} has successfully untrained the #{specialization.name} specialization."
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

  def obligation
    @character_menu = 'basics'
    @character_page = 'obligation'
    @title = "#{@character.name} | Obligation"
    @character_state = character_state(@character)
  end

  def obligation_selection
    unless params[:obligation_id].blank?
      @obligation = Obligation.find(params[:obligation_id])

      render :partial => "obligation_info", :locals => { :obligation => @obligation, :character_obligation => nil, :active => nil }
    else
      render :partial => "obligation_info", :locals => { :obligation => nil, :character_obligation => nil, :active => nil }
    end
  end

  def add_obligation
    unless params[:character_obligation][:obligation_id].nil?
      @obligation = CharacterObligation.where(:character_id => @character.id, :obligation_id => params[:character_obligation][:obligation_id], :magnitude => 0).create
    end
    flash[:success] = "Obligation added"
    redirect_to :back
  end

  def update_obligation
    unless params[:character_obligation][:character_obligation_id].nil?
      @obligation = CharacterObligation.where(:id => params[:character_obligation][:character_obligation_id]).first
      unless @obligation.nil?
        @obligation.description = params[:character_obligation][:description]
        @obligation.magnitude = params[:character_obligation][:magnitude]
        @obligation.save
      end
    end
    flash[:success] = "Obligation updated"
    redirect_to :back
  end

  def remove_obligation
    CharacterObligation.find(params[:obligation_id]).destroy
    flash[:success] = "Obligation removed"
    redirect_to :back
  end

  def motivation
    @character_menu = 'basics'
    @character_page = 'motivation'
    @title = "#{@character.name} | Motivation"
    @character_state = character_state(@character)
  end

  def motivation_selection
    unless params[:motivation_id].blank?
      @motivation = Motivation.find(params[:motivation_id])

      render :partial => "motivation_info", :locals => { :motivation => @motivation, :character_motivation => nil, :active => nil }
    else
      render :partial => "motivation_info", :locals => { :motivation => nil, :character_motivation => nil, :active => nil }
    end
  end

  def add_motivation
    unless params[:character_motivation][:motivation_id].nil?
      @motivation = CharacterMotivation.where(:character_id => @character.id, :motivation_id => params[:character_motivation][:motivation_id], :magnitude => 0).create
    end
    flash[:success] = "Motivation added"
    redirect_to :back
  end

  def update_motivation
    unless params[:character_motivation][:character_motivation_id].nil?
      @motivation = CharacterMotivation.where(:id => params[:character_motivation][:character_motivation_id]).first
      unless @motivation.nil?
        @motivation.description = params[:character_motivation][:description]
        @motivation.save
      end
    end
    flash[:success] = "Motivation updated"
    redirect_to :back
  end

  def remove_motivation
    CharacterMotivation.find(params[:motivation_id]).destroy
    flash[:success] = "Motivation removed"
    redirect_to :back
  end

  def armor
    @character_menu = 'equipment'
    @character_page = 'armor'
    @title = "#{@character.name} | Armor"
    @character_state = character_state(@character)
  end

  def armor_attachment
    @character_armor = CharacterArmor.find(params[:character_armor_id])
    @armor = Armor.find(@character_armor.armor_id)
    @title = "#{@character.name} | Armor Attachment"
    @character_state = Array.new

    @armor_attachments = CharacterArmorAttachment.where(:character_armor_id => params[:character_armor_id]).order(:id)

    @hard_points_used = 0
    @armor_attachments.each do |attachment|
      @hard_points_used += ArmorAttachment.where(:id => attachment.armor_attachment_id).first.hard_points
    end

    @hard_point_meter = ((@hard_points_used.to_f / @armor.hard_points.to_f) * 100)
    @hard_point_meter_class = ''
    if @hard_point_meter > 100
      @hard_point_meter_class = 'alert'
    end
    if @hard_point_meter == 100
      @hard_point_meter_class = 'success'
    end
  end

  def armor_attachment_selection
    unless params[:attachment_id].blank?
      @attachment = ArmorAttachment.find(params[:attachment_id])

      render :partial => "armor_attachment_info", :locals => { :attachment => @attachment, :character_attachment_id => nil, :active => nil, :armor_attachment_options => nil}
    else
      render :partial => "armor_attachment_info", :locals => { :attachment => nil, :character_attachment_id => nil, :active => nil, :armor_attachment_options => nil}
    end
  end

  def add_armor_attachment
    @armor_attachments = CharacterArmorAttachment.where(:character_armor_id => params[:character_armor_id], :armor_attachment_id => params[:character_armor_attachment][:armor_attachment_id]).first_or_create
    flash[:success] = "Attachment added"
    redirect_to :back
  end

  def remove_armor_attachment
    CharacterArmorAttachment.where(:id => params[:attachment_id]).destroy_all
    flash[:success] = "Attachment removed"
    redirect_to :back
  end

  def add_armor_attachment_option
    armor_attachment = CharacterArmorAttachment.where(:id => params[:attachment_id]).first

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => @character.id).first
      if character_skill.free_ranks_equipment.nil?
        character_skill.free_ranks_equipment = 1
      else
        character_skill.free_ranks_equipment += 1
      end
      character_skill.save
    end

    if armor_attachment.armor_attachment_modification_options.nil?
      armor_attachment.armor_attachment_modification_options = Array.new
    end
    armor_attachment.armor_attachment_modification_options << params[:option_id]
    armor_attachment.armor_attachment_modification_options = armor_attachment.armor_attachment_modification_options.uniq
    armor_attachment.save

    flash[:success] = "Modification option added."
    redirect_to :back
  end

  def remove_armor_attachment_option
    armor_attachment = CharacterArmorAttachment.where(:id => params[:attachment_id]).first
    armor_attachment.armor_attachment_modification_options.delete_at armor_attachment.armor_attachment_modification_options.index(params[:option_id].to_s)
    armor_attachment.save

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => @character.id).first
      character_skill.free_ranks_equipment -= 1
      character_skill.save
    end

    flash[:success] = "Modification option removed."
    redirect_to :back
  end

  def weapons
    @character_menu = 'equipment'
    @character_page = 'weapons'
    @title = "#{@character.name} | Weapons"
    @character_state = character_state(@character)
  end

  def weapon_attachment
    @character_weapon = CharacterWeapon.find(params[:character_weapon_id])
    @weapon = Weapon.find(@character_weapon.weapon_id)
    @title = "#{@character.name} | Weapon Attachment"
    @character_state = Array.new

    @weapon_attachments = CharacterWeaponAttachment.where(:character_weapon_id => params[:character_weapon_id]).order(:id)

    @hard_points_used = 0
    @weapon_attachments.each do |attachment|
      @hard_points_used += WeaponAttachment.where(:id => attachment.weapon_attachment_id).first.hard_points
    end

    @hard_point_meter = ((@hard_points_used.to_f / @weapon.hard_points.to_f) * 100)
    @hard_point_meter_class = ''
    if @hard_point_meter > 100
      @hard_point_meter_class = 'alert'
    end
    if @hard_point_meter == 100
      @hard_point_meter_class = 'success'
    end
  end

  def weapon_attachment_selection
    unless params[:attachment_id].blank?
      @attachment = WeaponAttachment.find(params[:attachment_id])

      render :partial => "weapon_attachment_info", :locals => { :attachment => @attachment, :character_attachment_id => nil, :active => nil, :weapon_attachment_options => nil}
    else
      render :partial => "weapon_attachment_info", :locals => { :attachment => nil, :character_attachment_id => nil, :active => nil, :weapon_attachment_options => nil}
    end
  end

  def add_weapon_attachment
    @weapon_attachments = CharacterWeaponAttachment.where(:character_weapon_id => params[:character_weapon_id], :weapon_attachment_id => params[:character_weapon_attachment][:weapon_attachment_id]).first_or_create
    flash[:success] = "Attachment added"
    redirect_to :back
  end

  def remove_weapon_attachment
    CharacterWeaponAttachment.where(:id => params[:attachment_id]).delete_all
    flash[:success] = "Attachment removed"
    redirect_to :back
  end

  def add_weapon_attachment_option
    weapon_attachment = CharacterWeaponAttachment.where(:id => params[:attachment_id]).first

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => @character.id).first
      if character_skill.free_ranks_equipment.nil?
        character_skill.free_ranks_equipment = 1
      else
        character_skill.free_ranks_equipment += 1
      end
      character_skill.save
    end

    if weapon_attachment.weapon_attachment_modification_options.nil?
      weapon_attachment.weapon_attachment_modification_options = Array.new
    end
    weapon_attachment.weapon_attachment_modification_options << params[:option_id]
    weapon_attachment.save

    flash[:success] = "Modification option added."
    redirect_to :back
  end

  def remove_weapon_attachment_option
    weapon_attachment = CharacterWeaponAttachment.where(:id => params[:attachment_id]).first
    weapon_attachment.weapon_attachment_modification_options.delete_at weapon_attachment.weapon_attachment_modification_options.index(params[:option_id].to_s)
    weapon_attachment.save

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => @character.id).first
      character_skill.free_ranks_equipment -= 1
      character_skill.save
    end

    flash[:success] = "Modification option removed."
    redirect_to :back
  end

  def equipment
    @character_menu = 'equipment'
    @character_page = 'gear'
    @title = "#{@character.name} | Equipment"
    @character_state = character_state(@character)
  end

  def equipment_selection
    if params[:gear_id]
      item = Gear.find(params[:gear_id])
      render :partial => "gear_info", :locals => { :gear => item}
    else
      render :partial => "gear_info", :locals => { :gear => nil}
    end
  end

  def add_equipment
    if params[:character_gears]
      item = Gear.find(params[:character_gears][:gear_id]) unless params[:character_gears][:gear_id].blank?

      if item
        character_gear = CharacterGear.where(:character_id => @character.id, :gear => params[:character_gears][:gear_id]).create
        character_gear.update_attribute(:carried, params[:character_gears][:carried])
        character_gear.update_attribute(:qty, params[:character_gears][:qty])
        flash[:success] = "#{item.name} added"
      else
        flash[:error] = "Item not found."
      end
    elsif params[:character_custom_gears]
      @custom_gear = CharacterCustomGear.new(
        :character_id => @character.id,
        :description => params[:character_custom_gears][:description],
        :carried => params[:character_custom_gears][:carried],
        :encumbrance => params[:character_custom_gears][:encumbrance],
        :qty => params[:character_custom_gears][:qty],
      )

      if @custom_gear.save
        flash[:success] = "Custom item added."
      else
        flash[:error] = "Custom item not added. Description can not be blank."
      end
    end
    redirect_to :back
  end

  def increase_equipment_qty
    if params[:custom]
      item = CharacterCustomGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty + 1)
      name = item.description
    else
      item = CharacterGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty + 1)
      name = item.gear.name
    end
    flash[:success] = "'#{name}' count increased"
    redirect_to :back
  end

  def decrease_equipment_qty
    if params[:custom]
      item = CharacterCustomGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty - 1)
      name = item.description
    else
      item = CharacterGear.find(params[:character_gear_id])
      item.update_attribute(:qty, item.qty - 1)
      name = item.gear.name
    end
    flash[:success] = "'#{name}' count decreased"
    redirect_to :back
  end

  def remove_equipment
    if params[:custom]
      item = CharacterCustomGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first
      name = item.description
    else
      item = CharacterGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first
      name = item.gear.name
    end
    item.delete
    flash[:success] = "'#{name}' removed"
    redirect_to :back
  end

  def place_equipment
    if params[:custom]
      item = CharacterCustomGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first

      if params[:action_id] == 'storage'
        item.update_attribute(:carried, :false)
        flash[:success] = "'#{item.description}' moved to storage."
      else
        item.update_attribute(:carried, 1)
        flash[:success] = "'#{item.description}' moved to inventory."
      end
    else
      item = CharacterGear.where(:character_id => @character.id, :id => params[:character_gear_id]).first

      if params[:action_id] == 'storage'
        item.update_attribute(:carried, :false)
        flash[:success] = "'#{item.gear.name}' moved to storage."
      else
        item.update_attribute(:carried, 1)
        flash[:success] = "'#{item.gear.name}' moved to inventory."
      end
    end

    redirect_to :back

  end

  def force_powers
    @character_page = 'forcepowers'
    @title = "#{@character.name} | Force Powers"
    @character_state = character_state(@character)

    @force_powers = CharacterForcePower.where(:character_id => @character.id).order(:id)
  end

  def force_power_selection
    if params[:force_power_id]
      @power = ForcePower.find(params[:force_power_id])

      render :partial => "force_power_info", :locals => { :power => @power, :character_force_power_id => nil, :active => nil, :force_power_upgrades => nil}
    else
      render :partial => "force_power_info", :locals => { :power => nil, :character_force_power_id => nil, :active => nil, :force_power_upgrades => nil}
    end
  end

  def add_force_power
    force_power = ForcePower.find(params[:character_force_power][:force_power_id]) unless params[:character_force_power][:force_power_id].blank?

    if force_power
      CharacterForcePower.where(:character_id => @character.id, :force_power_id => params[:character_force_power][:force_power_id]).first_or_create
      set_experience_cost('force_power', force_power.id, 10, 'up')
      flash[:success] = "Force Power added"
    else
      flash[:error] = "Force Power not found."
    end
    redirect_to :back
  end

  def remove_force_power
    CharacterForcePower.where(:character_id => @character.id, :force_power_id => params[:force_power_id]).delete_all
    CharacterForcePowerUpgrade.where(:character_id => @character.id, :force_power_id => params[:force_power_id]).delete_all
    set_experience_cost('force_power', params[:force_power_id], 1, 'down')
    flash[:success] = "Force Power removed"
    redirect_to :back
  end

  def add_force_power_upgrade
    CharacterForcePowerUpgrade.where(:character_id => @character.id, :force_power_id => params[:force_power_id], :force_power_upgrade_id => params[:force_power_upgrade_id]).first_or_create

    @force_powers = CharacterForcePower.where(:character_id => @character.id).order(:id)
    upgrade = ForcePowerUpgrade.where(:id => params[:force_power_upgrade_id]).first
    flash[:success] = "Added <strong>'#{upgrade.name}'</strong> upgrade to the <strong>'#{upgrade.force_power.name}'</strong> Force Power ."
    set_experience_cost('force_power_upgrade', params[:force_power_id], upgrade.cost, 'up')

    respond_to do |format|
      format.js  {}
    end
  end

  def remove_force_power_upgrade
    CharacterForcePowerUpgrade.where(:character_id => @character.id, :force_power_id => params[:force_power_id], :force_power_upgrade_id => params[:force_power_upgrade_id]).delete_all

    @force_powers = CharacterForcePower.where(:character_id => @character.id).order(:id)
    upgrade = ForcePowerUpgrade.where(:id => params[:force_power_upgrade_id]).first
    flash[:success] = "Removed <strong>'#{upgrade.name}'</strong> upgrade from the <strong>'#{upgrade.force_power.name}'</strong> Force Power ."
    set_experience_cost('force_power_upgrade', params[:force_power_id], upgrade.cost, 'down')

    respond_to do |format|
      format.js  {}
    end
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
    @character = Character.friendly.find(params[:id])
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
      character_armor_attributes: [ :id, :armor_id, :description, :equipped, :carried, :_destroy ],
      character_force_powers_attributes: [ :id, :force_power_id, :character_id, :_destroy ],
    )
  end
end
