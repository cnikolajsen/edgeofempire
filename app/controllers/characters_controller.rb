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
    
    @soak = @character.brawn
    @defense = 0 
    
    # Add armor values to soak and defense.
    if !@character.character_armor.nil?
      @soak += @character.character_armor.armor.soak
      @defense += @character.character_armor.armor.defense
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

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to @character, notice: 'Character was successfully updated.' }
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
    
    #logger.debug @character.character_skills.inspect
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
    
    #@armor = Armor.find(:all)
  end

  def armor
    @character_page = 'armor'
    @character = Character.find(params[:id])
    
    if !@character.character_armor.armor_id.nil?
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
