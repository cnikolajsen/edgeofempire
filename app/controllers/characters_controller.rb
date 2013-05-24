class CharactersController < ApplicationController
  #prawnto :prawn => { :size => "A4", :margin => 0, :font => 'Times-Roman' }
  include TalentsHelper
  include RacesHelper

  before_filter :set_up
  before_filter :authenticate_user!

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.find_all_by_user_id(current_user.id)

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
    @character.character_talents.each do |talent_tree|
      talent_tree.attributes.each do |key, value|
        if key.match(/talent_[\d]_[\d]/) and !value.nil?
          if @talents.has_key?(value)
            @talents[value] = @talents[value] + 1
          else
            @talents[value] = 1
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

    # Determine starting wound threshold. Species stat plus brawn.
    @wound_th = @character.brawn
    if !@character.race.wound_threshold.nil?
      @wound_th += @character.race.wound_threshold
      talent_alterations.each do |talent_id, stat|
        stat.each do |type, value|
          if type == 'wound'
            @wound_th += value
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
          if type == 'strain'
            @strain_th += value
          end
        end
      end
    end
    # Then increase based on selected talents.

    @soak = @character.brawn
    @defense = 0
    @equipment = Array.new
    @pdf_weapons_and_armor = Array.new
    @pdf_personal_gear = Array.new

    # Add weapons to equipment list
    if !@character.character_weapons.nil?
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

          if params[:format] != 'pdf'
            dice = render_to_string "_dice_pool", :locals => {:score => @character.send(cw.weapon.skill.characteristic.downcase), :ranks => ranks}, :layout => false

            @equipment << "#{cw.weapon.name} (#{cw.weapon.skill.name} [#{dice}]; Damage: #{cw.weapon.damage}; Critical: #{cw.weapon.crit}; Range: #{cw.weapon.range}; #{@wq.join(', ')})"
          else
            @pdf_weapons_and_armor << cw.weapon.name
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
        if type == 'soak'
          @soak += value
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
logger.debug(race_alterations)
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
    @title = "#{@character.name} | #{@title}"
    @character_page = 'basics'
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(params[:character])
    @character.user_id = current_user.id

    @character.brawn = @character.race.brawn
    @character.agility = @character.race.agility
    @character.intellect = @character.race.intellect
    @character.cunning = @character.race.cunning
    @character.willpower = @character.race.willpower
    @character.presence = @character.race.presence
    @character.experience = @character.race.starting_experience

    respond_to do |format|
      if @character.save

        Skill.find(:all).each do |skill|
          @character_skill = CharacterSkill.new()
          @character_skill.character_id = @character.id
          @character_skill.ranks = 0
          @character_skill.skill_id = skill.id
          @character_skill.save
        end

        @character_armor = CharacterArmor.new()
        @character_armor.character_id = @character.id
        @character_armor.armor_id = nil
        @character_armor.save

        format.html { redirect_to @character, notice: 'Character was successfully created.' }
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

    # Update talents.
    if !params[:update_talents].nil?
      @character.character_talents.each do |ct|
        ct.destroy
      end
      
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
      
      #@character.career.talent_trees.each do |tree|
      @talent_trees.each do |tree|
        @character_talent_tree = CharacterTalent.new()
        @character_talent_tree.character_id = @character.id
        @character_talent_tree.talent_tree_id = tree.id

        # Update first row talents.
        if !params["tree_#{tree.id}-talent_1_1".to_sym].nil?
          @character_talent_tree.talent_1_1 = tree.talent_1_1
        end
        if !params["tree_#{tree.id}-talent_1_2".to_sym].nil?
          @character_talent_tree.talent_1_2 = tree.talent_1_2
        end
        if !params["tree_#{tree.id}-talent_1_3".to_sym].nil?
          @character_talent_tree.talent_1_3 = tree.talent_1_3
        end
        if !params["tree_#{tree.id}-talent_1_4".to_sym].nil?
          @character_talent_tree.talent_1_4 = tree.talent_1_4
        end

        # Update second row talents.
        if !params["tree_#{tree.id}-talent_2_1".to_sym].nil?
          @character_talent_tree.talent_2_1 = tree.talent_2_1
        end
        if !params["tree_#{tree.id}-talent_2_2".to_sym].nil?
          @character_talent_tree.talent_2_2 = tree.talent_2_2
        end
        if !params["tree_#{tree.id}-talent_2_3".to_sym].nil?
          @character_talent_tree.talent_2_3 = tree.talent_2_3
        end
        if !params["tree_#{tree.id}-talent_2_4".to_sym].nil?
          @character_talent_tree.talent_2_4 = tree.talent_2_4
        end

        # Update third row talents.
        if !params["tree_#{tree.id}-talent_3_1".to_sym].nil?
          @character_talent_tree.talent_3_1 = tree.talent_3_1
        end
        if !params["tree_#{tree.id}-talent_3_2".to_sym].nil?
          @character_talent_tree.talent_3_2 = tree.talent_3_2
        end
        if !params["tree_#{tree.id}-talent_3_3".to_sym].nil?
          @character_talent_tree.talent_3_3 = tree.talent_3_3
        end
        if !params["tree_#{tree.id}-talent_3_4".to_sym].nil?
          @character_talent_tree.talent_3_4 = tree.talent_3_4
        end

        # Update fourth row talents.
        if !params["tree_#{tree.id}-talent_4_1".to_sym].nil?
          @character_talent_tree.talent_4_1 = tree.talent_4_1
        end
        if !params["tree_#{tree.id}-talent_4_2".to_sym].nil?
          @character_talent_tree.talent_4_2 = tree.talent_4_2
        end
        if !params["tree_#{tree.id}-talent_4_3".to_sym].nil?
          @character_talent_tree.talent_4_3 = tree.talent_4_3
        end
        if !params["tree_#{tree.id}-talent_4_4".to_sym].nil?
          @character_talent_tree.talent_4_4 = tree.talent_4_4
        end

        # Update fifth row talents.
        if !params["tree_#{tree.id}-talent_5_1".to_sym].nil?
          @character_talent_tree.talent_5_1 = tree.talent_5_1
        end
        if !params["tree_#{tree.id}-talent_5_2".to_sym].nil?
          @character_talent_tree.talent_5_2 = tree.talent_5_2
        end
        if !params["tree_#{tree.id}-talent_5_3".to_sym].nil?
          @character_talent_tree.talent_5_3 = tree.talent_5_3
        end
        if !params["tree_#{tree.id}-talent_5_4".to_sym].nil?
          @character_talent_tree.talent_5_4 = tree.talent_5_4
        end

        @character_talent_tree.save
      end
    end
    
    # Update character skill entries for character to add in new skills created since the character was created.
    existing_skills = Array.new
    @character.character_skills.each do |skill|
      existing_skills << skill.skill.id
    end
    Skill.find(:all).each do |skill|
      if !existing_skills.include?(skill.id)
        @character_skill = CharacterSkill.new()
        @character_skill.character_id = @character.id
        @character_skill.ranks = 0
        @character_skill.skill_id = skill.id
        @character_skill.save
      end
    end

    respond_to do |format|
      if @character.update_attributes(params[:character])
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
    
    @career_skill_ids = Array.new
    @character.career.talent_trees.each do |tt|
      tt.talent_tree_career_skills.each do |skill|
        @career_skill_ids << skill.skill_id
      end
    end
    @character.career.career_skills.each do |skill|
      @career_skill_ids << skill.skill_id
    end
  end

  def talents
    @character_page = 'talents'
    @character = Character.find(params[:id])

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

  def armor
    @character_page = 'armor'
    @character = Character.find(params[:id])

    if !@character.character_armor.nil?
      @armor = Armor.find_by_id(@character.character_armor.armor_id)
    end
  end

  def weapons
    @character_page = 'weapons'
    @character = Character.find(params[:id])

  end

  def equipment
    @character_page = 'gear'
    @character = Character.find(params[:id])

  end

  private

  def set_up
    @page = 'characters'
    @character_page = 'basics'
    @title = "Characters"
  end

end
