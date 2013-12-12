class CharactersController < ApplicationController
  #prawnto :prawn => { :size => "A4", :margin => 0, :font => 'Times-Roman' }
  include TalentsHelper
  include RacesHelper
  include CharactersHelper

  before_filter :set_up
  before_filter :authenticate_user!

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.where(:user_id => current_user.id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @characters }
    end
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    @character_page = 'view'

    @character = Character.find(params[:id])
    @title = "#{@character.name} | #{@title}"
    @character_state = character_state(@character)

    @experience_cost = character_experience_cost(@character)

    @specializations = Array.new
    unless @character.specialization_1.nil?
      @specializations << TalentTree.find_by_id(@character.specialization_1).name
    end
    unless @character.specialization_2.nil?
      @specializations << TalentTree.find_by_id(@character.specialization_2).name
    end
    unless @character.specialization_3.nil?
      @specializations << TalentTree.find_by_id(@character.specialization_3).name
    end

    # Build character talent selection.
    @talents = {}
    unless @character.character_talents.empty?
      @character.character_talents.each do |talent_tree|
        talent_tree.attributes.each do |key, value|

          if key.match(/talent_[\d]_[\d]$/) and !value.nil?
            if @talents.has_key?(value) && !talent_tree["#{key}_options"].nil?
              @talents[value]['count'] = @talents[value]['count'] + 1
              talent_tree["#{key}_options"].each do |opt|
                opt_test = opt.to_i
                if opt_test.is_a? Integer and opt_test > 0
                  @talents[value]['options'] << Skill.find_by_id(opt).name
                else
                  @talents[value]['options'] << opt.capitalize
                end
              end
            else
              @talents[value] = {}
              @talents[value]['count'] = 1
              @talents[value]['options'] = Array.new
              unless talent_tree["#{key}_options"].nil?
                unless talent_tree["#{key}_options"].empty?
                  talent_tree["#{key}_options"].each do |opt|
                    opt_test = opt.to_i
                    if opt_test.is_a? Integer and opt_test > 0
                      @talents[value]['options'] << Skill.find_by_id(opt).name
                    else
                      @talents[value]['options'] << opt.capitalize
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    character_bonus_talents = CharacterBonusTalent.where(:character_id => @character.id)
    unless character_bonus_talents.empty?
      character_bonus_talents.each do |bt|
        talent_ranks = RaceTalent.where(:race_id => @character.race.id, :talent_id => bt.talent_id).first#.ranks
        unless talent_ranks.nil?
          if @talents.has_key?(bt.talent_id)
            @talents[bt.talent_id]['count'] = @talents[bt.talent_id]['count'] + talent_ranks.ranks
          else
            @talents[bt.talent_id] = {}
            @talents[bt.talent_id]['count'] = talent_ranks.ranks
            @talents[bt.talent_id]['options'] = Array.new
          end
        end
      end
    end

    talent_alterations = {}
    @talents.each do |id, count|
      name = Talent.find(id).name.gsub(' ', '').downcase
      if respond_to?("talent_parser_#{name}")
        talent_alterations[id] = {}
        talent_alterations[id] = send("talent_parser_#{name}", count)
      end
    end

    # Determine characteristic increases from talents.
    talent_alterations.each do |talent_id, stat|
      stat.each do |type, value|
        if type == :on_purchase && value[:type] == :select_characteristic
          if @talents[talent_id]['options'].include?('Brawn') && @character.brawn < 6
            @character.brawn += 1
          end
          if @talents[talent_id]['options'].include?('Agility') && @character.agility < 6
            @character.agility += 1
          end
          if @talents[talent_id]['options'].include?('Cunning') && @character.cunning < 6
            @character.cunning += 1
          end
          if @talents[talent_id]['options'].include?('Intellect') && @character.intellect < 6
            @character.intellect += 1
          end
          if @talents[talent_id]['options'].include?('Presence') && @character.presence < 6
            @character.presence += 1
          end
          if @talents[talent_id]['options'].include?('Willpower') && @character.willpower < 6
            @character.willpower += 1
          end
        end
      end
    end

    # Determine starting wound threshold. Species stat plus brawn.
    @wound_th = @character.brawn
    if !@character.race.wound_threshold.nil?
      @wound_th += @character.race.wound_threshold
      talent_alterations.each do |talent_id, stat|
        stat.each do |type, value|
          if type == :wound
            @wound_th += value['count']
          end
        end
      end
    end
    # Then increase based on selected talents.

    # Determine starting strain threshold. Species stat plus willpower.
    @strain_th = @character.willpower
    if !@character.race.strain_threshold.nil?
      @strain_th += @character.race.strain_threshold
      talent_alterations.each do |talent_id, stat|
        stat.each do |type, value|
          if type == :strain
            @strain_th += value['count']
          end
        end
      end
    end
    # Then increase based on selected talents.

    @soak = @character.brawn
    @defense = 0
    @equipment = Array.new
    @attacks = Array.new
    @pdf_weapons_and_armor = Array.new
    @pdf_personal_gear = Array.new

    # Add weapons to equipment list
    if !@character.character_weapons.nil?
      unarmed_weapon = Weapon.where(:name => 'Unarmed').first

      @character.character_weapons.each do |cw|
        unless cw.weapon.nil? or cw.weapon.name == 'Unarmed'
          if params[:format] != 'pdf'
            @equipment << "#{cw.weapon.name}"
          else
            @pdf_weapons_and_armor << cw.weapon.name
          end
        end
      end

      # Build attacks list.
      @character.character_weapons.each do |cw|
        unless cw.weapon.nil?
          @wq = Array.new
          cw.weapon.weapon_quality_ranks.each do |q|
            ranks = ''
            if q.ranks > 0
              ranks = " #{q.ranks}"
            end
            @wq << "#{WeaponQuality.find_by_id(q.weapon_quality_id).name}#{ranks}"
          end

          character_skill_ranks = CharacterSkill.where("character_id = ? AND skill_id = ?", @character.id, cw.weapon.skill.id)
          ranks = character_skill_ranks.first.ranks

          if cw.weapon.skill.name == 'Brawl'
            cw.weapon.damage = @character.brawn

            if cw.weapon.name == 'Unarmed'
              # Trandoshans have claws.
              if @character.race.name == 'Trandoshan'
                cw.weapon.name = 'Claws'
                cw.weapon.damage += 1
                cw.weapon.crit = 3
              end
            end

            talent_alterations.each do |talent_id, stat|
              stat.each do |type, value|
                if type == :brawl_damage_bonus
                  cw.weapon.damage += value['count']
                end
              end
            end
          end

          if cw.weapon.skill.name == 'Melee'
            talent_alterations.each do |talent_id, stat|
              stat.each do |type, value|
                if type == :melee_damage_bonus
                  cw.weapon.damage += value['count']
                end
              end
            end
          end

          if params[:format] != 'pdf'
            dice = render_to_string "_dice_pool", :locals => {:score => @character.send(cw.weapon.skill.characteristic.downcase), :ranks => ranks}, :layout => false

            @attacks << "<strong>#{cw.weapon.name}</strong> (#{cw.weapon.skill.name} #{dice}; Damage: #{cw.weapon.damage}; Critical: #{cw.weapon.crit}; Range: #{cw.weapon.range}; #{@wq.join(', ')})"
          else
            #@pdf_weapons_and_armor << cw.weapon.name
          end
        end
      end
    end

    # Add armor values to soak and defense and armor to equipment list.
    if !@character.character_armor.nil? and !@character.character_armor.armor_id.nil?
      @soak += @character.character_armor.armor.soak
      @defense += @character.character_armor.armor.defense
      @equipment << "#{@character.character_armor.armor.name} (+#{@character.character_armor.armor.soak} soak, +#{@character.character_armor.armor.defense} defense)"
      @pdf_weapons_and_armor << @character.character_armor.armor.name
    end

    talent_alterations.each do |talent_id, stat|
      stat.each do |type, value|
        if type == :soak
          @soak += value['count']
        end
      end
    end

    # Add general items to equipment list
    if !@character.character_gears.nil?
      @character.character_gears.each do |cg|
        @equipment << "#{cg.gear.name}#{' (' unless cg.qty < 2}#{cg.qty unless cg.qty < 2}#{')' unless cg.qty < 2}"
        @pdf_personal_gear << "#{cg.gear.name}#{' (' unless cg.qty < 2}#{cg.qty unless cg.qty < 2}#{')' unless cg.qty < 2}"
      end
    end

    # Apply species special abilities.
    race_alterations = {}
    if respond_to?("special_ability_#{@character.race.name.gsub(' ', '').gsub("'", "").downcase}")
      race_alterations = {}
      race_alterations = send("special_ability_#{@character.race.name.gsub(' ', '').gsub("'", "").downcase}")
    end

    error_messages = ''
    # Show error messages if some combination of species and career/specialization free ranks go above 2 during character creation.
    if @character.creation?
      @character.character_skills.each do |character_skill|
        if character_skill.ranks > 2
          error_messages += "<i class='icon-thumbs-down'> You have more than the allowed <strong>2 ranks</strong> at character creation in the skill <strong>#{character_skill.skill.name}</strong>. Check your free bonus ranks from either species, career, or specialization.</i><br />"
        end
      end
    end

    # Validate free ranks from career selection.
    career_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').each do |career_skill|
      career_free_rank << career_skill.skill_id
    end

    if @character.career.name == 'Droid'
      career_free_rank_max_count = 6
    else
      career_free_rank_max_count = 4
    end

    if career_free_rank.count > career_free_rank_max_count
      error_messages += "<i class='icon-thumbs-down'> You have selected too many career skills to place a free rank in. The #{@character.race.name} species allows you to choose <strong>#{career_free_rank_max_count} skills</strong>, but you have chosen <strong>#{career_free_rank.count} skills</strong>.</i><br />"
    end

    unless error_messages.blank?
      flash.now[:error] = error_messages
    end

    # Specific for the PDF.
    pdf_vars = Hash.new
    if params[:format] == 'pdf'
      if params[:gfx] == 'off'
        pdf_vars['pdf_background'] = 'off'
        pdf_vars['pdf_border_color'] = "000000"
      else
        pdf_vars['pdf_background'] = 'on'
        pdf_vars['pdf_border_color'] = "c8c8c8"
      end
    end
    pdf_vars['soak'] = @soak
    pdf_vars['wound_th'] = @wound_th
    pdf_vars['strain_th'] = @strain_th
    pdf_vars['defense'] = @defense
    pdf_vars['weapons_armor'] = @pdf_weapons_and_armor
    pdf_vars['personal_gear'] = @pdf_personal_gear
    pdf_vars['talents'] = @talents
    pdf_vars['specializations'] = @specializations

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @character }
      format.pdf do
        pdf = CharacterSheetPdf.new(@character, view_context, pdf_vars)
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
    @character = Character.find(params[:id])
    @character_state = character_state(@character)

    @career_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').each do |career_skill|
      @career_free_rank << career_skill.skill_id
    end

    @title = "#{@character.name} | Edit"
    @character_page = 'basics'
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(character_params)
    @character.user_id = current_user.id

    unless @character.race.nil?
      @character.brawn = @character.race.brawn
      @character.agility = @character.race.agility
      @character.intellect = @character.race.intellect
      @character.cunning = @character.race.cunning
      @character.willpower = @character.race.willpower
      @character.presence = @character.race.presence
      @character.experience = @character.race.starting_experience

      save_character_racial_talents(@character)
    end

    respond_to do |format|
      if @character.save

        Skill.where(true).each do |skill|
          race_skill = RaceSkill.where(:skill_id => skill.id, :race_id => @character.race.id).first

          @character_skill = CharacterSkill.new()
          @character_skill.character_id = @character.id
          @character_skill.ranks = 0
          @character_skill.free_ranks_career = 0
          @character_skill.free_ranks_specialization = 0
          @character_skill.free_ranks_race = 0
          @character_skill.skill_id = skill.id

          unless race_skill.nil?
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'race', :ranks => race_skill.ranks).first_or_create
            @character_skill.free_ranks_race = race_skill.ranks
            @character_skill.ranks = race_skill.ranks
          end

          @character_skill.save
        end

        @character_armor = CharacterArmor.new()
        @character_armor.character_id = @character.id
        @character_armor.armor_id = nil
        @character_armor.save

        format.html { redirect_to edit_character_path(@character), notice: 'Character was successfully created.' }
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
    @character = Character.find(params[:id])

    @career_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').each do |career_skill|
      @career_free_rank << career_skill.skill_id
    end

    # Handle resets due to career change.
    if !params[:original_career_id].nil? and params[:character][:career_id] != params[:original_career_id]
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').delete_all
      CharacterSkill.where(:character_id => @character.id).each do |skill|
        skill.ranks -= skill.free_ranks_career
        skill.free_ranks_career = 0
        skill.save
      end
    end

    # Handle resets due to species change.
    if !params[:original_race_id].nil? and params[:character][:race_id] != params[:original_race_id]
      # Delete all free skill ranks granted by the old species.
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'race').delete_all
      CharacterSkill.where(:character_id => @character.id).each do |skill|
        skill.ranks -= skill.free_ranks_race
        skill.free_ranks_race = 0
        skill.save
      end

      # Adjust characteristic minimums.
      new_race = Race.find(params[:character][:race_id])
      if @character.brawn < new_race.brawn
        params[:character][:brawn] = new_race.brawn
      end
      if @character.agility < new_race.agility
        params[:character][:agility] = new_race.agility
      end
      if @character.cunning < new_race.cunning
        params[:character][:cunning] = new_race.cunning
      end
      if @character.willpower < new_race.willpower
        params[:character][:willpower] = new_race.willpower
      end
      if @character.presence < new_race.presence
        params[:character][:presence] = new_race.presence
      end
      if @character.intellect < new_race.intellect
        params[:character][:intellect] = new_race.intellect
      end

      # Save free skill ranks granted by the new species.
      new_race.skills.each do |skill|
        race_skill = RaceSkill.where(:skill_id => skill.id, :race_id => new_race.id).first
        CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'race', :ranks => race_skill.ranks).first_or_create
        character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
        if character_skill.free_ranks_race == 0 or character_skill.free_ranks_race.blank?
          character_skill.free_ranks_race = race_skill.ranks
          character_skill.ranks += race_skill.ranks
          character_skill.save
        end
      end
    end

    if @character.aasm_state.nil?
      @character.aasm_state = 'creation'
    end

    if @character.character_armor.nil?
      @character_armor = CharacterArmor.new()
      @character_armor.character_id = @character.id
      @character_armor.armor_id = nil
      @character_armor.save
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

    # Save career skills to add a free rank to.
    unless params[:free_career_skill_rank].nil?
      @character.career.skills.each do |skill|
        if params[:free_career_skill_rank].include? skill.id.to_s
          CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'career', :ranks => 1).first_or_create
          character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
          if character_skill.free_ranks_career == 0 or character_skill.free_ranks_career.blank?
            character_skill.free_ranks_career = 1
            character_skill.ranks += 1
            character_skill.save
          end
        else
          CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'career').delete_all
          character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
          unless character_skill.free_ranks_career.blank? or character_skill.free_ranks_career == 0
            character_skill.free_ranks_career -= 1
            character_skill.ranks -= 1
            character_skill.save
          end
        end
      end
    end

    # Save a weapon entry for unarmed combat if not.
    unarmed_weapon = Weapon.where(:name => 'Unarmed').first
    @character_unarmed = CharacterWeapon.where(:character_id => @character.id, :weapon_id => unarmed_weapon.id).first_or_create
    if @character_unarmed.character_id.nil?
      @character_unarmed = CharacterWeapon.new()
      @character_unarmed.character_id = @character.id
      @character_unarmed.weapon_id = unarmed_weapon.id
      @character_unarmed.save
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

      # Save specialization skills to add a free rank to.
      unless params[:free_specialization_skill_rank].nil?
        specialization_skills = TalentTree.find_by_id(@character.specialization_1).skills
        specialization_skills.each do |skill|
          if params[:free_specialization_skill_rank].include? skill.id.to_s
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'specialization', :ranks => 1).first_or_create
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            if character_skill.free_ranks_specialization == 0 or character_skill.free_ranks_specialization.blank?
              character_skill.free_ranks_specialization = 1
              character_skill.ranks += 1
              character_skill.save
            end
          else
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'specialization').delete_all
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            unless character_skill.free_ranks_specialization.blank? or character_skill.free_ranks_specialization == 0
              character_skill.free_ranks_specialization -= 1
              character_skill.ranks -= 1
              character_skill.save
            end
          end
        end
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
            else
              @character_talent_tree["talent_#{r_key + 1}_#{c_key + 1}"] = nil
            end
          end
        end

        @character_talent_tree.save
      end
    end

    # Save racial talents.
    if !params[:character_basics].nil?
      save_character_racial_talents(@character)
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

    respond_to do |format|
      if @character.update_attributes(character_params)
        if !params[:original_race_id].nil? and @character.race_id != params[:original_race_id]
          format.html { redirect_to edit_character_path(@character), notice: 'Race was changed. Adjust your characteristics.' }
        elsif !params[:original_career_id].nil? and @character.career_id != params[:original_career_id]
          format.html { redirect_to edit_character_path(@character), notice: 'Career was changed. Adjust your free skill ranks.' }
        elsif !params[:destination].nil?
          if params[:destination] == 'gear'
            message = 'Character equipment updated.'
          elsif params[:destination] == 'weapons'
            message = 'Character weapons updated.'
          elsif params[:destination] == 'armor'
            message = 'Character armor updated.'
          elsif params[:destination] == 'talents'
            message = 'Character talents updated.'
          elsif params[:destination] == 'skills'
            message = 'Character skills updated.'
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
    @character = Character.find(params[:id])
    @character.destroy

    respond_to do |format|
      format.html { redirect_to characters_url, notice: 'Character was successfully deleted.'  }
      format.json { head :no_content }
    end
  end

  def skills
    @character_page = 'skills'
    @character = Character.find(params[:id])
    @title = "#{@character.name} | Skills"
    @character_state = character_state(@character)
  end

  def talents
    @character_page = 'talents'
    @character = Character.find(params[:id])
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
    @character = Character.find(params[:id])
    specialization = TalentTree.find(params[:spec_id])
    @character["specialization_#{params[:spec_num]}".to_sym] = nil
    @character.save
    CharacterTalent.where(:character_id => @character.id, :talent_tree_id => params[:spec_id]).delete_all
    if params[:spec_num] == 1
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').delete_all
    end
    redirect_to character_talents_url(:id => @character.id), notice: "#{@character.name} has successfully untrained the #{specialization.name} specialization."
  end

  def character_experience_cost(character)
    exp_cost = Hash.new

    exp_cost[:header_characteristics] = 0
    # @start Calculate experience spent buying characteristics.
    exp_cost[:brawn] = 0
    exp_cost[:agility] = 0
    exp_cost[:cunning] = 0
    exp_cost[:willpower] = 0
    exp_cost[:intellect] = 0
    exp_cost[:presence] = 0
    character.brawn.times do |time|
      exp_cost[:brawn] += (10 * (time + 1)).to_i
    end
    @character.race.brawn.times do |time|
      exp_cost[:brawn] -= (10 * (time + 1)).to_i
    end
    character.agility.times do |time|
      exp_cost[:agility] += 10 * (time + 1)
    end
    @character.race.agility.times do |time|
      exp_cost[:agility] -= 10 * (time + 1)
    end
    character.cunning.times do |time|
      exp_cost[:cunning] += 10 * (time + 1)
    end
    @character.race.cunning.times do |time|
      exp_cost[:cunning] -= 10 * (time + 1)
    end
    character.willpower.times do |time|
      exp_cost[:willpower] += 10 * (time + 1)
    end
    @character.race.willpower.times do |time|
      exp_cost[:willpower] -= 10 * (time + 1)
    end
    character.intellect.times do |time|
      exp_cost[:intellect] += 10 * (time + 1)
    end
    @character.race.intellect.times do |time|
      exp_cost[:intellect] -= 10 * (time + 1)
    end
    character.presence.times do |time|
      exp_cost[:presence] += 10 * (time + 1)
    end
    @character.race.presence.times do |time|
      exp_cost[:presence] -= 10 * (time + 1)
    end
    # @end Characteristics.

    exp_cost[:header_specializations] = 0
    # @start Calculate experience spent buying specializations.
    unless @character.specialization_1.blank?
      specialization = TalentTree.find(@character.specialization_1)
      exp_cost["#{specialization.name}".to_sym] = 0
    end
    unless @character.specialization_2.blank?
      specialization = TalentTree.find(@character.specialization_2)
      non_career_specialization_penalty = 10
      @character.career.talent_trees.each do |tree|
        if tree.id == @character.specialization_2
          non_career_specialization_penalty = 0
        end
      end
      exp_cost["#{specialization.name}".to_sym] = 20 + non_career_specialization_penalty
    end
    unless @character.specialization_3.blank?
      specialization = TalentTree.find(@character.specialization_3)
      non_career_specialization_penalty = 10
      @character.career.talent_trees.each do |tree|
        if tree.id == @character.specialization_3
          non_career_specialization_penalty = 0
        end
      end
      exp_cost["#{specialization.name}".to_sym] = 30 + non_career_specialization_penalty
    end
    # @end Specializations.

    # @start Calculate experience spent buying talents.
    talents = {}
    unless @character.character_talents.empty?
      exp_cost[:header_talents] = 0
      @character.character_talents.each do |talent_tree|
        talent_tree.attributes.each do |key, value|
          if key.match(/talent_[\d]_[\d]$/) and !value.nil?
            if talents.has_key?(value) && !talent_tree["#{key}_options"].nil?
              talents[value]['count'] = talents[value]['count'] + 1
            else
              talents[value] = {}
              talents[value]['count'] = 1
            end

            talent_cost = 0
            # find the experience cost from the row number in the key.
            # Keys are build like this talent_#{row}_#{column}.
            case key
            when /^talent_1/
              talent_cost = 5
            when /^talent_2/
              talent_cost = 10
            when /^talent_3/
              talent_cost = 15
            when /^talent_4/
              talent_cost = 20
            when /^talent_5/
              talent_cost = 25
            end

            talent = Talent.find(value)
            specialization = TalentTree.find(talent_tree.talent_tree_id)
            exp_cost["#{specialization.name}_#{talent.name}_rank_#{talents[value]['count']}".to_sym] = talent_cost
          end
        end
      end
    end
    # @end Talents.

    # @start Calculate experience spent buying skills.
    unless @character.character_skills.empty?
      exp_cost[:header_skills] = 0
      @character.character_skills.each do |cs|
        skill = Skill.find(cs.skill_id)
        free_ranks = cs.free_ranks_career + cs.free_ranks_specialization + cs.free_ranks_race
        skill_cost = 0
        cs.ranks.times do |rank|
          skill_cost += (5 * (rank + 1)).to_i
        end
        free_ranks.times do |rank|
          skill_cost -= (5 * (rank + 1)).to_i
        end

        unless skill_cost == 0
          exp_cost["#{cs.ranks - free_ranks}_#{'rank'.pluralize(cs.ranks)}_in_#{skill.name}".to_sym] = skill_cost
        end
      end
    end
    # @end Skills.

    # Sum up the total.
    exp_cost[:total_cost] = exp_cost.inject(0){|a,(_,b)|a+b}

    exp_cost
  end

  def armor
    @character_page = 'armor'
    @character = Character.find(params[:id])
    @title = "#{@character.name} | Armor"

    if !@character.character_armor.nil?
      @armor = Armor.find_by_id(@character.character_armor.armor_id)
    end
  end

  def weapons
    @character_page = 'weapons'
    @character = Character.find(params[:id])
    @title = "#{@character.name} | Weapons"
  end

  def equipment
    @character_page = 'gear'
    @character = Character.find(params[:id])
    @title = "#{@character.name} | Equipment"
  end

  def set_activate
    @character = Character.find(params[:id])
    @character.activate
    @character.save
    redirect_to @character, notice: 'Character activated. Character creation rules no longer apply.'
  end

  def set_retired
    @character = Character.find(params[:id])
    @character.retire
    @character.save
    redirect_to @character, notice: 'Character taken off duty. Character is now read only.'
  end

  def set_creation
    @character = Character.find(params[:id])
    @character.set_create
    @character.save
    redirect_to @character, notice: 'Character put into creation mode. Special rules apply.'
  end

  private

  def set_up
    @page = 'characters'
    @character_page = 'basics'
    @title = "Characters"
  end

  def save_character_racial_talents(character)
    character_racial_talents = CharacterBonusTalent.where(:character_id => character.id, :bonus_type => 'racial')

    unless character_racial_talents.nil?
      character_racial_talents.each do |bt|
        bt.destroy
      end
    end

    unless character.race.talents.nil?
      character.race.talents.each do |talent|
        character_bonus_talent = CharacterBonusTalent.new()
        character_bonus_talent.character_id = character.id
        character_bonus_talent.talent_id = talent.id
        character_bonus_talent.bonus_type = 'racial'
        character_bonus_talent.save
      end
    end
  end

  def character_params
    # This is not quite right, but for some reason I don't have the character
    # parameter when saving character talents...
    unless params[:character].nil?

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
        character_gears_attributes: [ :id, :gear_id, :qty, :_destroy ],
        character_weapons_attributes: [ :id, :weapon_id, :description, :_destroy ],
        character_obligations_attributes: [ :id, :character_id, :obligation_id, :_destroy ],
        character_skills_attributes: [ :id, :character_id, :ranks, :skill_id ],
        character_armor_attributes: [ :id, :armor_id, :description, :_destroy ]
      )
    end
  end

end
