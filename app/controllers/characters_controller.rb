class CharactersController < ApplicationController
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

    # Determine starting wound threshold. Species stat plus brawn.
    @wound_th = @character.brawn
    if !@character.race.wound_threshold.nil?
      @wound_th += @character.race.wound_threshold
    end
    # Then increase based on selected talents.

    # Determine starting strain threshold. Species stat plus willpower.
    @strain_th = @character.willpower
    if !@character.race.strain_threshold.nil?
      @strain_th += @character.race.strain_threshold
    end
    # Then increase based on selected talents.

    @soak = @character.brawn
    @defense = 0
    @equipment = Array.new

    # Add weapons to equipment list
    if !@character.character_weapons.nil?
      @character.character_weapons.each do |cw|
        unless cw.weapon.nil?
          @wq = Array.new
          cw.weapon.weapon_quality_ranks.each do |q|
            @wq << "#{WeaponQuality.find_by_id(q.weapon_quality_id).name}#{' ' unless q.ranks = 0}#{q.ranks unless q.ranks = 0}"
          end
          @equipment << "#{cw.weapon.name} (#{cw.weapon.skill.name}; Damage: #{cw.weapon.damage}; Critical: #{cw.weapon.crit}; Range: #{cw.weapon.range}; #{@wq})"
        end
      end
    end

    # Add armor values to soak and defense and armor to equipment list.
    if !@character.character_armor.nil? and !@character.character_armor.armor_id.nil?
      @soak += @character.character_armor.armor.soak
      @defense += @character.character_armor.armor.defense
      @equipment << "#{@character.character_armor.armor.name} (+#{@character.character_armor.armor.soak} soak, +#{@character.character_armor.armor.defense} defense)"
    end

    # Add general items to equipment list
    if !@character.character_gears.nil?
      @character.character_gears.each do |cg|
        @equipment << "#{cg.gear.name}#{' (' unless cg.qty < 2}#{cg.qty unless cg.qty < 2}#{')' unless cg.qty < 2}"
      end
    end


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @character }
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
        if cg.qty < 1
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
      @character.career.talent_trees.each do |tree|
        #@character_talent_tree = CharacterTalent.where("talent_tree_id = ? AND character_id = ?", tree.id, @character.id)
        #if @character_talent.empty?
        @character_talent_tree = CharacterTalent.new()
        @character_talent_tree.character_id = @character.id
        @character_talent_tree.talent_tree_id = tree.id
        #end

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

        @character_talent_tree.save
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
  end

  def talents
    @character_page = 'talents'
    @character = Character.find(params[:id])

    @talent_trees = Array.new
    @character.career.talent_trees.each do |tree|
      @talent_trees << tree
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
