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

    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | #{@title}"
    @character_state = character_state(@character)

    @experience_cost = character_experience_cost(@character.id)

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

    # Find equipped armor.
    equipped_armor = CharacterArmor.where(:character_id => @character.id, :equipped => :true).first
    @character_armor_modification_bonuses = {}
    @character_armor_modification_bonuses['skills'] = Array.new
    @character_armor_modification_bonuses['talents'] = Array.new
    unless equipped_armor.nil? or equipped_armor.character_armor_attachments.blank?
      equipped_armor.character_armor_attachments.each do |caa|
        caa.armor_attachment_modification_options.each do |option|
          modification_option = ArmorAttachmentModificationOption.find(option)
          unless modification_option.talent_id.nil?
            @character_armor_modification_bonuses['talents'] << modification_option.talent_id
          end
          unless modification_option.skill_id.nil?
            @character_armor_modification_bonuses['skills'] << modification_option.skill_id
          end
        end
      end
    end

    # Find equipped weapons.
    equipped_weapons = CharacterWeapon.where(:character_id => @character.id, :equipped => :true).first
    @character_weapon_modification_bonuses = {}
    @character_weapon_modification_bonuses['skills'] = Array.new
    @character_weapon_modification_bonuses['talents'] = Array.new
    unless equipped_weapons.blank? or equipped_weapons.character_weapon_attachments.blank?
      equipped_weapons.character_weapon_attachments.each do |caa|
        unless caa.weapon_attachment_modification_options.nil?
          caa.weapon_attachment_modification_options.each do |option|
            modification_option = WeaponAttachmentModificationOption.find(option)
            unless modification_option.talent_id.nil?
              @character_weapon_modification_bonuses['talents'] << modification_option.talent_id
            end
            unless modification_option.skill_id.nil?
              @character_weapon_modification_bonuses['skills'] << modification_option.skill_id
            end
          end
        end
      end
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

    # Include talent alterations from equipped armor.
    unless @character_armor_modification_bonuses['talents'].blank?
      @character_armor_modification_bonuses['talents'].each do |armor_talents|
        if @talents.has_key?(armor_talents)
          @talents[armor_talents]['count'] = @talents[armor_talents]['count'] + 1
        else
          @talents[armor_talents] = {}
          @talents[armor_talents]['count'] = 1
          @talents[armor_talents]['options'] = Array.new
        end
      end
    end
    # Include talent alterations from equipped weapons.
    unless @character_weapon_modification_bonuses['talents'].blank?
      @character_weapon_modification_bonuses['talents'].each do |weapon_talents|
        if @talents.has_key?(weapon_talents)
          @talents[weapon_talents]['count'] = @talents[weapon_talents]['count'] + 1
        else
          @talents[weapon_talents] = {}
          @talents[weapon_talents]['count'] = 1
          @talents[weapon_talents]['options'] = Array.new
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
    unless @character.race.nil?
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
    end
    # Then increase based on selected talents.

    # Determine starting strain threshold. Species stat plus willpower.
    @strain_th = @character.willpower
    unless @character.race.nil?
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
        if cw.weapon_model_id.nil?
          weapon_name = cw.weapon.name
        else
          weapon_name = WeaponModel.find(cw.weapon_model_id).name
        end

        unless cw.character_weapon_attachments.blank?
          weapon_name = "Modified " + weapon_name
        end

        unless cw.weapon.nil? or cw.weapon.name == 'Unarmed'
          if params[:format] != 'pdf'
            @equipment << "#{weapon_name}"
          else
            @pdf_weapons_and_armor << weapon_name
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
          if character_skill_ranks.first.nil?
            ranks = 0
          else
            ranks =  character_skill_ranks.first.ranks
          end

          if cw.weapon.skill.name == 'Brawl'
            cw.weapon.damage = @character.brawn

            if cw.weapon.name == 'Unarmed'
              # Trandoshans have claws.
              if !@character.race.nil? and @character.race.name == 'Trandoshan'
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

          unless cw.weapon_model_id.nil?
            cw.weapon.name = WeaponModel.find(cw.weapon_model_id).name
          end

          unless cw.character_weapon_attachments.blank?
            cw.weapon.name = "Modified " + cw.weapon.name
          end

          weapon_attachment = Array.new
          cw.character_weapon_attachments.each do |cwa|
            weapon_attachment << WeaponAttachment.find(cwa.weapon_attachment_id).name
            unless cwa.weapon_attachment_modification_options.nil?
              cwa.weapon_attachment_modification_options.each do |option|
                modification_option = WeaponAttachmentModificationOption.find(option)
                unless modification_option.weapon_quality_id.nil?
                  wq_ranks = ''
                  if modification_option.weapon_quality_rank > 0
                    wq_ranks = " #{modification_option.weapon_quality_rank}"
                  end
                  @wq << "#{WeaponQuality.find_by_id(modification_option.weapon_quality_id).name}#{wq_ranks}"
                end
                unless modification_option.damage_bonus.nil?
                  cw.weapon.damage += modification_option.damage_bonus
                end
                unless modification_option.custom.blank?
                  weapon_attachment << "#{modification_option.custom}"
                end
              end
            end
          end

          attachment_text = nil
          unless weapon_attachment.blank?
            attachment_text = "; [<strong>Attachments:</strong> #{weapon_attachment.join(', ')}]"
          end

          if params[:format] != 'pdf'
            dice = render_to_string "_dice_pool", :locals => {:score => @character.send(cw.weapon.skill.characteristic.downcase), :ranks => ranks}, :layout => false

            @attacks << "<strong>#{cw.weapon.name}</strong> (#{cw.weapon.skill.name} #{dice}; Damage: #{cw.weapon.damage}; Critical: #{cw.weapon.crit}; Range: #{cw.weapon.range}; #{@wq.join(', ')}#{attachment_text})"
          else
            #@pdf_weapons_and_armor << cw.weapon.name
          end
        end
      end
    end

    armor_applied = :false
    if !@character.character_armor.nil?
      @character.character_armor.each do |ca|
        unless ca.armor_model_id.nil?
          ca.armor.name = ArmorModel.find(ca.armor_model_id).name
        end

        unless ca.character_armor_attachments.blank?
          ca.armor.name = "Modified " + ca.armor.name
        end

        if ca.equipped?
          if armor_applied == :false
            @soak += ca.armor.soak
            @defense += ca.armor.defense
            armor_applied = :true
            @equipment << "#{ca.armor.name} (+#{ca.armor.soak} soak, +#{ca.armor.defense} defense)"
            @pdf_weapons_and_armor << ca.armor.name
          end
        else
          @equipment << "#{ca.armor.name}"
        end
      end
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
        unless cg.gear_model_id.nil?
          cg.gear.name = GearModel.find(cg.gear_model_id).name
        end

        @equipment << "#{cg.gear.name}#{' (' unless cg.qty < 2}#{cg.qty unless cg.qty < 2}#{')' unless cg.qty < 2}"
        @pdf_personal_gear << "#{cg.gear.name}#{' (' unless cg.qty < 2}#{cg.qty unless cg.qty < 2}#{')' unless cg.qty < 2}"
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
          error_messages += "<i class='icon-thumbs-down'> You have more than the allowed <strong>2 ranks</strong> at character creation in the skill <strong>#{character_skill.skill.name}</strong>. Check your free bonus ranks from either species, career, or specialization.</i><br />"
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
    pdf_vars['available_xp'] = @experience_cost[:available_experience]
    pdf_vars['total_xp'] = @experience_cost[:starting_experience] + @experience_cost[:earned_experience]
    pdf_vars['force_rank'] = 0

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
    @character = Character.friendly.find(params[:id])
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
    @character.brawn = 1
    @character.agility = 1
    @character.intellect = 1
    @character.cunning = 1
    @character.willpower = 1
    @character.presence = 1
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

        format.html { redirect_to character_species_url(@character), notice: 'Character was successfully created.' }
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
    @character = Character.friendly.find(params[:id])
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
              character_skill.save
            end
          else
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'specialization').delete_all
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            unless character_skill.free_ranks_specialization.blank? or character_skill.free_ranks_specialization == 0
              character_skill.free_ranks_specialization -= 1
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

    # Save character career.
    if !params[:character_career].nil? and !@character.career.nil?
      # Handle resets due to career change.
      if !params[:original_career_id].nil? and params[:character][:career_id] != params[:original_career_id]
        CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').delete_all
        CharacterSkill.where(:character_id => @character.id).each do |skill|
          skill.free_ranks_career = 0
          skill.save
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
              character_skill.save
            end
          else
            CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'career').delete_all
            character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
            unless character_skill.free_ranks_career.blank? or character_skill.free_ranks_career == 0
              character_skill.free_ranks_career -= 1
              character_skill.save
            end
          end
        end
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

    # Save character species.
    if !params[:character_species].nil?
      species = Race.find(params[:character][:race_id])
      @character.update_attribute(:brawn, species.brawn)
      @character.update_attribute(:agility, species.agility)
      @character.update_attribute(:intellect, species.intellect)
      @character.update_attribute(:cunning, species.cunning)
      @character.update_attribute(:willpower, species.willpower)
      @character.update_attribute(:presence, species.presence)

      # Save racial talents.
      character_racial_talents = CharacterBonusTalent.where(:character_id => @character.id, :bonus_type => 'racial')
      unless character_racial_talents.nil?
        character_racial_talents.each do |bt|
          bt.destroy
        end
      end

      unless species.talents.nil?
        species.talents.each do |talent|
          character_bonus_talent = CharacterBonusTalent.new()
          character_bonus_talent.character_id = @character.id
          character_bonus_talent.talent_id = talent.id
          character_bonus_talent.bonus_type = 'racial'
          character_bonus_talent.save
        end
      end

      # Save racial skill ranks, but only on initial save.
      if params[:original_race_id].blank?
        RaceSkill.where(:race_id => species.id).each do |race_skill|
          @character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => race_skill.skill_id).first
          unless @character_skill.nil?
            @character_skill.free_ranks_race = race_skill.ranks
            @character_skill.save
          end

          CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => race_skill.id, :granted_by => 'race', :ranks => race_skill.ranks).first_or_create
        end
      end

      # Handle resets due to species change.
      if !params[:original_race_id].blank? and params[:character][:race_id] != params[:original_race_id]
        # Delete all free skill ranks granted by the old species.
        CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'race').delete_all
        CharacterSkill.where(:character_id => @character.id).each do |skill|
          skill.free_ranks_race = 0
          skill.save
        end

        # Adjust characteristic minimums.
        new_race = Race.find(params[:character][:race_id])
        if @character.brawn < new_race.brawn
          @character.update_attribute(:brawn, new_race.brawn)
        end
        if @character.agility < new_race.agility
          @character.update_attribute(:agility, new_race.agility)
        end
        if @character.cunning < new_race.cunning
          @character.update_attribute(:cunning, new_race.cunning)
        end
        if @character.willpower < new_race.willpower
          @character.update_attribute(:willpower, new_race.willpower)
        end
        if @character.presence < new_race.presence
          @character.update_attribute(:presence, new_race.presence)
        end
        if @character.intellect < new_race.intellect
          @character.update_attribute(:intellect, new_race.intellect)
        end

        # Save free skill ranks granted by the new species.
        new_race.skills.each do |skill|
          race_skill = RaceSkill.where(:skill_id => skill.id, :race_id => new_race.id).first
          CharacterStartingSkillRank.where(:character_id => @character.id, :skill_id => skill.id, :granted_by => 'race', :ranks => race_skill.ranks).first_or_create
          character_skill = CharacterSkill.where(:character_id => @character.id, :skill_id => skill.id).first_or_create
          if character_skill.free_ranks_race == 0 or character_skill.free_ranks_race.blank?
            character_skill.free_ranks_race = race_skill.ranks
            character_skill.save
          end
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
          elsif params[:destination] == 'career'
            message = 'Character career saved.'
            if !params[:original_career_id].nil? and @character.career_id != params[:original_career_id]
              message = "Career was changed. Reselect your free skill ranks."
            end
          elsif params[:destination] == 'species'
            message = 'Character species saved.'
            if !params[:original_race_id].nil? and @character.race_id != params[:original_race_id]
              message = "Character species has changed. You might want to adjust your #{view_context.link_to('characteristics', character_characteristics_url(@character))}."
            end
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
    @character = Character.friendly.find(params[:id])
    @character.destroy

    respond_to do |format|
      format.html { redirect_to characters_url, notice: 'Character was successfully deleted.'  }
      format.json { head :no_content }
    end
  end

  def skills
    @character_page = 'skills'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Skills"
    @character_state = character_state(@character)
  end

  def save_character_skills
    params[:character_skills].each do |skill_rank|
      character_skill = CharacterSkill.where(:character_id => params[:id], :skill_id => skill_rank[0]).first
      character_skill.ranks = skill_rank[1]
      character_skill.save
    end
    redirect_to :back, :notice => "Skills updated"
  end

  def talents
    @character_page = 'talents'
    @character = Character.friendly.find(params[:id])
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
    @character = Character.friendly.find(params[:id])
    specialization = TalentTree.find(params[:spec_id])
    @character["specialization_#{params[:spec_num]}".to_sym] = nil
    @character.save
    CharacterTalent.where(:character_id => @character.id, :talent_tree_id => params[:spec_id]).delete_all
    if params[:spec_num] == 1
      CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'specialization').delete_all
    end
    redirect_to character_talents_url(:id => @character.id), notice: "#{@character.name} has successfully untrained the #{specialization.name} specialization."
  end

  def career
    @character_menu = 'career'
    @character_page = 'career'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Career"
    @character_state = character_state(@character)

    @career_free_rank = Array.new()
    CharacterStartingSkillRank.where(:character_id => @character.id, :granted_by => 'career').each do |career_skill|
      @career_free_rank << career_skill.skill_id
    end
  end

  def career_selection
    @career = Career.find(params[:career_id])

    render :partial => "career_info", :locals => { :career => @career, :changed => :true }
  end

  def species
    @character_menu = 'basics'
    @character_page = 'species'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Species"
    @character_state = character_state(@character)
  end

  def species_selection
    @species = Race.find(params[:species_id])

    render :partial => "species_info", :locals => { :species => @species, :changed => :true }
  end

  def characteristics
    @character_menu = 'basics'
    @character_page = 'characteristics'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Characteristics"
    @character_state = character_state(@character)
  end

  def background
    @character_menu = 'basics'
    @character_page = 'background'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Background"
    @character_state = character_state(@character)
  end

  def obligation
    @character_menu = 'basics'
    @character_page = 'obligation'
    @character = Character.friendly.find(params[:id])
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
      @obligation = CharacterObligation.where(:character_id => params[:id], :obligation_id => params[:character_obligation][:obligation_id], :magnitude => 0).create
    end
    redirect_to :back, :notice => "Obligation added"
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
    redirect_to :back, :notice => "Obligation updated"
  end

  def remove_obligation
    CharacterObligation.find(params[:obligation_id]).destroy
    redirect_to :back, :notice => "Obligation removed"
  end

  def motivation
    @character_menu = 'basics'
    @character_page = 'motivation'
    @character = Character.friendly.find(params[:id])
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
      @motivation = CharacterMotivation.where(:character_id => params[:id], :motivation_id => params[:character_motivation][:motivation_id], :magnitude => 0).create
    end
    redirect_to :back, :notice => "Motivation added"
  end

  def update_motivation
    unless params[:character_motivation][:character_motivation_id].nil?
      @motivation = CharacterMotivation.where(:id => params[:character_motivation][:character_motivation_id]).first
      unless @motivation.nil?
        @motivation.description = params[:character_motivation][:description]
        @motivation.save
      end
    end
    redirect_to :back, :notice => "Motivation updated"
  end

  def remove_motivation
    CharacterMotivation.find(params[:motivation_id]).destroy
    redirect_to :back, :notice => "Motivation removed"
  end

  def armor
    @character_menu = 'equipment'
    @character_page = 'armor'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Armor"
  end

  def armor_attachment
    @character = Character.friendly.find(params[:id])
    @character_armor = CharacterArmor.find(params[:character_armor_id])
    @armor = Armor.find(@character_armor.armor_id)
    @title = "#{@character.name} | Armor Attachment"

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

      render :partial => "armor_attachment_info", :locals => { :attachment => @attachment , :active => nil, :armor_attachment_options => nil}
    else
      render :partial => "armor_attachment_info", :locals => { :attachment => nil, :active => nil, :armor_attachment_options => nil}
    end
  end

  def add_armor_attachment
    @armor_attachments = CharacterArmorAttachment.where(:character_armor_id => params[:character_armor_id], :armor_attachment_id => params[:character_armor_attachment][:armor_attachment_id]).first_or_create
    redirect_to :back, :notice => "Attachment added"
  end

  def remove_armor_attachment
    CharacterArmorAttachment.where(:armor_attachment_id => params[:attachment_id]).delete_all
    redirect_to :back, :notice => "Attachment removed"
  end

  def add_armor_attachment_option
    armor_attachment = CharacterArmorAttachment.where(:armor_attachment_id => params[:attachment_id]).first

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => params[:id]).first
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
    armor_attachment.save

    redirect_to :back, :notice => "Modification option added."
  end

  def remove_armor_attachment_option
    armor_attachment = CharacterArmorAttachment.where(:armor_attachment_id => params[:attachment_id]).first
    armor_attachment.armor_attachment_modification_options.delete_at armor_attachment.armor_attachment_modification_options.index(params[:option_id].to_s)
    armor_attachment.save

    attachment_option = ArmorAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => params[:id]).first
      character_skill.free_ranks_equipment -= 1
      character_skill.save
    end

    redirect_to :back, :notice => "Modification option removed."
  end

  def weapons
    @character_menu = 'equipment'
    @character_page = 'weapons'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Weapons"
  end

  def weapon_attachment
    @character = Character.friendly.find(params[:id])
    @character_weapon = CharacterWeapon.find(params[:character_weapon_id])
    @weapon = Weapon.find(@character_weapon.weapon_id)
    @title = "#{@character.name} | Weapon Attachment"

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
    redirect_to :back, :notice => "Attachment added"
  end

  def remove_weapon_attachment
    CharacterWeaponAttachment.where(:id => params[:attachment_id]).delete_all
    redirect_to :back, :notice => "Attachment removed"
  end

  def add_weapon_attachment_option
    weapon_attachment = CharacterWeaponAttachment.where(:id => params[:attachment_id]).first

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => params[:id]).first
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

    redirect_to :back, :notice => "Modification option added."
  end

  def remove_weapon_attachment_option
    weapon_attachment = CharacterWeaponAttachment.where(:id => params[:attachment_id]).first
    weapon_attachment.weapon_attachment_modification_options.delete_at weapon_attachment.weapon_attachment_modification_options.index(params[:option_id].to_s)
    weapon_attachment.save

    attachment_option = WeaponAttachmentModificationOption.find(params[:option_id])
    unless attachment_option.skill_id.nil?
      character_skill = CharacterSkill.where(:skill_id => attachment_option.skill_id, :character_id => params[:id]).first
      character_skill.free_ranks_equipment -= 1
      character_skill.save
    end

    redirect_to :back, :notice => "Modification option removed."
  end

  def equipment
    @character_menu = 'equipment'
    @character_page = 'gear'
    @character = Character.friendly.find(params[:id])
    @title = "#{@character.name} | Equipment"
  end

  def set_activate
    @character = Character.friendly.find(params[:id])
    @character.activate
    @character.save
    redirect_to @character, notice: 'Character activated. Character creation rules no longer apply.'
  end

  def set_retired
    @character = Character.friendly.find(params[:id])
    @character.retire
    @character.save
    redirect_to @character, notice: 'Character taken off duty. Character is now read only.'
  end

  def set_creation
    @character = Character.friendly.find(params[:id])
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
        character_gears_attributes: [ :id, :gear_id, :qty, :carried, :gear_model_id, :_destroy ],
        character_weapons_attributes: [ :id, :weapon_id, :description, :equipped, :carried, :weapon_model_id, :_destroy ],
        character_obligations_attributes: [ :id, :character_id, :obligation_id, :description, :magnitude, :_destroy ],
        character_skills_attributes: [ :id, :character_id, :ranks, :skill_id ],
        character_armor_attributes: [ :id, :armor_id, :description, :equipped, :carried, :armor_model_id, :_destroy ]
      )
    end
  end
end
