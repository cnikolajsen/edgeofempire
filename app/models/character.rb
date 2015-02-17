class Character < ActiveRecord::Base
  #validates :name, presence: true
  validates :race_id, presence: true
  validates :career_id, presence: true

  #scope :public, -> { where(:public => true).order('created_at desc') }
  #scope :private, -> { where(:public => false).order('created_at desc') }

  after_create :log_starting_experience
  after_create :set_species_stats
  after_create :save_unarmed_combat_entry

  include AASM
  include FriendlyId
  friendly_id :slug_candidates, :use => :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  def slug_candidates
    [
      :name,
      [:name, :career_id],
      [:name, :race_id],
      [:name, :career_id, :race_id],
    ]
  end

  aasm do
    state :creation, :initial => true
    state :active
    state :retired

    event :activate do
      transitions :from => :creation, :to => :active, :guard => :experience_exceeded?
    end

    event :retire do
      transitions :from => :active, :to => :retired
    end

    event :set_create do
      transitions :to => :creation
    end
  end

  def experience_exceeded?
    @character = Character.find(id)

    character_experience_cost = @character.character_experience_costs.sum(:cost)
    available_experience = @character.adventure_logs.sum(:experience)

    if @character.race.nil? || @character.career.nil?
      false
    elsif character_experience_cost > available_experience
      false
    else
      true
    end
  end

  belongs_to :user

  has_many :character_skills, :dependent => :destroy
  has_many :skills, -> { order 'skills.name' }, :through => :character_skills
  has_many :character_armor, :dependent => :destroy
  has_many :armors, :through => :character_armor
  has_many :character_weapons, :dependent => :destroy
  has_many :weapons, :through => :character_weapons
  has_many :character_gears, :dependent => :destroy
  has_many :gears, :through => :character_gears
  has_many :character_custom_gears, :dependent => :destroy
  has_many :character_obligations, :dependent => :destroy
  has_many :obligations, :through => :character_obligations
  has_many :character_duties, dependent: :destroy
  has_many :duties, through: :character_duties
  has_many :character_motivations, dependent: :destroy
  has_many :motivations, through: :character_motivations
  has_many :character_force_powers, :dependent => :destroy
  has_many :force_powers, :through => :character_force_powers
  has_many :character_cybernetics, :dependent => :destroy
  has_many :gears, :through => :character_cybernetics
  has_many :character_criticals, :dependent => :destroy

  has_many :character_talents, :dependent => :destroy
  has_many :talents, :through => :character_talents

  has_many :character_bonus_talents, :dependent => :destroy
  has_many :character_starting_skill_ranks, :dependent => :destroy

  has_many :adventure_logs, :dependent => :destroy

  has_many :character_experience_costs, :dependent => :destroy

  belongs_to :race
  belongs_to :career

  accepts_nested_attributes_for :character_skills, :allow_destroy => true
  accepts_nested_attributes_for :character_armor, :reject_if => proc { |a| a['armor_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_weapons, :reject_if => proc { |a| a['weapon_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_gears, :reject_if => proc { |a| a['gear_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_custom_gears, :allow_destroy => true
  accepts_nested_attributes_for :character_force_powers, :reject_if => proc { |a| a['force_power_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_obligations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_motivations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_talents, :allow_destroy => true
  accepts_nested_attributes_for :character_starting_skill_ranks, :allow_destroy => true
  accepts_nested_attributes_for :adventure_logs, :allow_destroy => true
  accepts_nested_attributes_for :character_criticals, :reject_if => proc { |a| a['effect'].blank? }, :allow_destroy => true

  default_scope { order('name ASC') }

  def purchased_skills
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'skill', :granted_by => '')
  end

  def selected_skill_ranks_career
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'skill', :granted_by => 'career')
  end

  def selected_skill_ranks_specialization
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'skill', :granted_by => 'specialization')
  end

  def selected_skill_ranks_racial_trait
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'skill', :granted_by => 'racial_trait')
  end


  def free_skill_ranks_career
    career_free_skill_ranks = if self.race.name == 'Droid' then 6 else 4 end
  end

  def free_skill_ranks_specialization
    specialization_free_skill_ranks = if self.race.name == 'Droid' then 3 else 2 end
  end

  def free_skill_ranks_racial_trait
    racial_trait_free_skill_ranks = 0
    if self.race.respond_to?("#{self.race.name.gsub(' ', '').downcase}_traits")
      traits = self.race.send("#{self.race.name.gsub(' ', '').downcase}_traits")
      if traits[:bonus_non_class_skill_ranks]
        racial_trait_free_skill_ranks = traits[:bonus_non_class_skill_ranks]
      end
    end
    racial_trait_free_skill_ranks
  end

  # Determine Soak. Brawn plus armor plus talents.
  def soak
    soak = self.brawn

    if self.equipped_armor
      soak += self.equipped_armor.armor.soak
    end

    # Then increase based on selected talents.
    self.talent_alterations.each do |talent_id, stat|
      stat.each do |type, value|
        if type == :soak
          soak += value['count']
        end
      end
    end

    # Add soak increase from cybenetics.
    self.cybernetics[:bonuses].each do |cb|
      if cb[0] == :soak
        soak += cb[1]
      end
    end

    soak
  end

  def defense
    defense = 0
    if self.equipped_armor
      defense += self.equipped_armor.armor.defense
    end
    defense
  end

  # Determine strain threshold. Species stat plus willpower.
  def strain_threshold
    strain_th = self.willpower
    if self.race && self.race.strain_threshold
      strain_th += self.race.strain_threshold
    end
    # Then increase based on selected talents.
    self.talent_alterations.each do |talent_id, stat|
      stat.each do |type, value|
        if type == :strain
          strain_th += value['count']
        end
      end
    end
    strain_th
  end

  # Determine starting wound threshold. Species stat plus brawn.
  def wound_threshold
    wound_th = self.brawn
    if self.race && self.race.wound_threshold
      wound_th += self.race.wound_threshold
    end
    # Then increase based on selected talents.
    self.talent_alterations.each do |talent_id, stat|
      stat.each do |type, value|
        if type == :wound
          wound_th += value
        end
      end
    end
    wound_th
  end

  def encumbrance_threshold
    et = brawn + 5
    inventory(carried: true).each do |inv|
      et += 4 if inv[:name] == 'Backpack'
      et += 3 if inv[:name] == 'Creshaldyne Mk. IV Modular Backpack'
      if inv[:name] == 'Modular Backpack Extra Pouch'
        enc_bonus = inv[:quantity]
        enc_bonus = 3 if enc_bonus > 3
        et += enc_bonus
      end
      et += 1 if inv[:name] == 'Utility Belt'
      et += 2 if inv[:name] == 'Spacer\'s Duffel'
      et += 2 if inv[:name] == 'Surveyor\'s Bag'
    end
    et
  end

  # Fetch character's force rating.
  def force_rating
    rating = 0
    # Force rating is 1 if either of the 3 specializations is a force tree.
    if self.specialization_1
      tree = TalentTree.find(self.specialization_1)
      if tree.force_tree
        rating = 1
      end
    end
    if self.specialization_2
      tree = TalentTree.find(self.specialization_2)
      if tree.force_tree
        rating = 1
      end
    end
    if self.specialization_3
      tree = TalentTree.find(self.specialization_3)
      if tree.force_tree
        rating = 1
      end
    end

    # Add one rank for each Force Rating talent.
    CharacterExperienceCost.where(:character_id => self.id, :resource_type => 'talent').each do |talent|
      if talent.resource_id && talent.resource_id > 0 && Talent.find(talent.resource_id).name == "Force Rating"
        rating += 1
      end
    end

    rating
  end

  def force_power_upgrades_computed
    force_powers_with_upgrade = Array.new
    self.character_force_powers.each do |fp|
      upgrades = Array.new
      CharacterForcePowerUpgrade.where(:character_id => self.id, :force_power_id => fp.force_power.id).each do |upg|
        if upg.force_power_upgrade.ranked
          if upgrades.select {|upgrade| upgrade['name'] == upg.force_power_upgrade.name }.blank?
            upgrades << {
              'name' => upg.force_power_upgrade.name,
              'description' => upg.force_power_upgrade.description,
              'rank' => 1
            }
          else
            upgrades.each do |upgrade|
              if upgrade['name'] == upg.force_power_upgrade.name
                upgrade['rank'] += 1
              end
            end
          end
        else
          upgrades << {
            'name' => upg.force_power_upgrade.name,
            'description' => upg.force_power_upgrade.description,
            'rank' => nil
          }
        end
      end

      force_powers_with_upgrade << {
        'name' => fp.force_power.name,
        'description' => fp.force_power.description,
        'upgrades' => upgrades
      }
    end

    force_powers_with_upgrade
  end

  def attacks
    attacks = Array.new

    # Build attacks list.
    self.character_weapons.each do |cw|
      if cw.weapon && cw.equipped?
        @wq = Array.new
        cw.weapon.weapon_quality_ranks.each do |q|
          ranks = 0
          if q.ranks > 0
            ranks = q.ranks
          end
          @wq << {
            :name => q.weapon_quality.name,
            :ranks => ranks,
          }
        end

        character_skill = CharacterSkill.where("character_id = ? AND skill_id = ?", self.id, cw.weapon.skill.id).first
        if character_skill.nil?
          ranks = 0
        else
          ranks = character_skill.ranks + character_skill.free_ranks_race + character_skill.free_ranks_career + character_skill.free_ranks_specialization + character_skill.free_ranks_equipment
        end

        if cw.weapon.skill.name == 'Brawl'
          cw.weapon.damage += self.brawn

          if cw.weapon.name == 'Unarmed'
            # Trandoshans have claws.
            if !self.race.nil? and self.race.name == 'Trandoshan'
              cw.weapon.name = 'Claws'
              cw.weapon.damage += 1
              cw.weapon.crit = 3
            end
          end

          self.talent_alterations.each do |talent_id, stat|
            stat.each do |type, value|
              if type == :brawl_damage_bonus
                cw.weapon.damage += value['count']
              end
            end
          end
        end

        if cw.weapon.skill.name == 'Melee'
          cw.weapon.damage += self.brawn
          self.talent_alterations.each do |talent_id, stat|
            stat.each do |type, value|
              if type == :melee_damage_bonus
                cw.weapon.damage += value['count']
              end
            end
          end
        end

        if !cw.custom_name.nil? && !cw.custom_name.blank?
          cw.weapon.name = cw.custom_name
        elsif !cw.weapon_model_id.nil?
          cw.weapon.name = WeaponModel.find(cw.weapon_model_id).name
        end

        if !cw.character_weapon_attachments.blank? && cw.custom_name.blank?
          cw.weapon.name = "Modified " + cw.weapon.name
        end

        weapon_attachment = Array.new
        cw.character_weapon_attachments.each do |cwa|
          weapon_attachment_damage_bonus = WeaponAttachment.find(cwa.weapon_attachment_id).damage_bonus
          unless weapon_attachment_damage_bonus.nil?
            cw.weapon.damage += weapon_attachment_damage_bonus
          end
          options = Array.new
          unless cwa.weapon_attachment_modification_options.nil?
            cwa.weapon_attachment_modification_options.each do |option|
              modification_option = WeaponAttachmentModificationOption.find(option)
              unless modification_option.weapon_quality_id.nil?
                wq_ranks = nil
                if modification_option.weapon_quality_rank > 0
                  wq_ranks = modification_option.weapon_quality_rank
                end
                @wq << {
                  :name => WeaponQuality.find_by_id(modification_option.weapon_quality_id).name,
                  :ranks => wq_ranks,
                }
              end
              unless modification_option.damage_bonus.nil?
                cw.weapon.damage += modification_option.damage_bonus
                options << "Damage +#{modification_option.damage_bonus}"
              end
              unless modification_option.custom.blank?
                options << modification_option.custom
              end
            end
          end

          weapon_attachment << {
            :name => WeaponAttachment.find(cwa.weapon_attachment_id).name,
            :options => options,
          }

        end

      attacks << {
        :weapon => cw.weapon,
        :skill => cw.weapon.skill,
        :ranks => ranks,
        :qualities => @wq,
        :attachments => weapon_attachment,
      }
      end
    end

    attacks
  end

  def specializations
    specializations = Array.new
    if self.specialization_1
      specializations << TalentTree.find_by_id(self.specialization_1).name
    end
    if self.specialization_2
      specializations << TalentTree.find_by_id(self.specialization_2).name
    end
    if self.specialization_3
      specializations << TalentTree.find_by_id(self.specialization_3).name
    end

    specializations
  end

  def talent_alterations
    talent_alterations = {}
    self.talents.each do |id, count|
      talent = Talent.find(id)
      name = talent.name.gsub(' ', '').downcase
      if talent.respond_to?("#{name}")
        talent_alterations[id] = {}
        talent_alterations[id] = talent.send("#{name}", count, self)
      end
    end

    talent_alterations
  end

  # Build character talent selection.
  def talents
    talents = {}
    unless self.character_talents.empty?
      self.character_talents.each do |talent_tree|
        talent_tree.attributes.each do |key, value|
          if key.match(/talent_[\d]_[\d]$/) and !value.nil?
            if talents.has_key?(value) && !talent_tree["#{key}_options"].nil?
              talents[value]['count'] = talents[value]['count'] + 1
              talent_tree["#{key}_options"].each do |opt|
                opt_test = opt.to_i
                if opt_test.is_a? Integer and opt_test > 0
                  talents[value]['options'] << Skill.find_by_id(opt).name
                else
                  talents[value]['options'] << opt.capitalize
                end
              end
            else
              talents[value] = {}
              talents[value]['count'] = 1
              talents[value]['options'] = Array.new
              unless talent_tree["#{key}_options"].nil?
                unless talent_tree["#{key}_options"].empty?
                  talent_tree["#{key}_options"].each do |opt|
                    opt_test = opt.to_i
                    if opt_test.is_a? Integer and opt_test > 0
                      talents[value]['options'] << Skill.find_by_id(opt).name
                    else
                      talents[value]['options'] << opt.capitalize
                    end
                  end
                end
              end
            end
          end
        end
      end
      talents
    end

    # Build the character cybernetics selection.
    def cybernetics
      cybernetics = Array.new
      items = Array.new
      bonus_arms = {
        :agility => nil,
        :brawn => nil
      }
      bonus_legs = {
        :agility => nil,
        :brawn => nil
      }
      bonus_head = {
        :intellect => nil
      }
      left_leg_active = false
      right_leg_active = false
      arms_active = false
      head_active = false
      bonus_soak = 0

      if self.character_cybernetics
        self.character_cybernetics.each do |cyb|
          bonus = nil
          unless cyb.gear_id.nil?
            if cyb.respond_to?("#{cyb.gear.name.gsub(/[^0-9a-z\\s]/i, '').downcase}")
              bonus = cyb.send("#{cyb.gear.name.gsub(/[^0-9a-z\\s]/i, '').downcase}")
              if bonus
                if !arms_active && (cyb.location == 'left_arm' || cyb.location == 'right_arm')
                  bonus_arms = bonus
                  arms_active = true
                end
                if cyb.location == 'left_leg'
                  left_leg_active = cyb.gear.id
                end
                if cyb.location == 'right_leg'
                  right_leg_active = cyb.gear.id
                end
                if left_leg_active == right_leg_active
                  bonus_legs = bonus
                end
                if !head_active && cyb.location == 'head'
                  bonus_head = bonus
                  head_active = true
                end
                if bonus[:soak]
                  bonus_soak = bonus[:soak]
                end
              end
            end

            items << {
              :name => cyb.gear.name,
              :location => cyb.location,
              :bonus => bonus
            }
          end
        end
      end

      cybernetics = {
        :items => items,
        :bonuses => {
          :agility => (bonus_arms[:agility] ? bonus_arms[:agility] : 0) + (bonus_legs[:agility] ? bonus_legs[:agility] : 0),
          :brawn => (bonus_arms[:brawn] ? bonus_arms[:brawn] : 0) + (bonus_legs[:brawn] ? bonus_legs[:brawn] : 0),
          :intellect => (bonus_head[:intellect] ? bonus_head[:intellect] : 0),
          :soak => bonus_soak,
        },
        :legs => left_leg_active == right_leg_active
      }

      cybernetics
    end

    character_bonus_talents = CharacterBonusTalent.where(:character_id => self.id)
    unless character_bonus_talents.empty?
      character_bonus_talents.each do |bt|
        talent_ranks = RaceTalent.where(:race_id => self.race.id, :talent_id => bt.talent_id).first#.ranks
        unless talent_ranks.nil?
          if talents.has_key?(bt.talent_id)
            talents[bt.talent_id]['count'] = talents[bt.talent_id]['count'] + talent_ranks.ranks
          else
            talents[bt.talent_id] = {}
            talents[bt.talent_id]['count'] = talent_ranks.ranks
            talents[bt.talent_id]['options'] = Array.new
          end
        end
      end
    end

    # Include talent alterations from equipped armor.
    if self.armor_modification_bonuses['talents']
      self.armor_modification_bonuses['talents'].each do |armor_talents|
        if talents.has_key?(armor_talents)
          talents[armor_talents]['count'] = talents[armor_talents]['count'] + 1
        else
          talents[armor_talents] = {}
          talents[armor_talents]['count'] = 1
          talents[armor_talents]['options'] = Array.new
        end
      end
    end
    # Include talent alterations from equipped weapons.
    if self.weapon_modification_bonuses['talents']
      self.weapon_modification_bonuses['talents'].each do |weapon_talents|
        if talents.has_key?(weapon_talents)
          talents[weapon_talents]['count'] = talents[weapon_talents]['count'] + 1
        else
          talents[weapon_talents] = {}
          talents[weapon_talents]['count'] = 1
          talents[weapon_talents]['options'] = Array.new
        end
      end
    end
    talents
  end

  # Find equipped armor.
  def equipped_armor
    CharacterArmor.where(:character_id => self.id, :equipped => :true).first
  end

  def armor_modification_bonuses
    modification_bonuses = {}
    modification_bonuses['skills'] = Array.new
    modification_bonuses['talents'] = Array.new
    modification_bonuses['characteristics'] = Array.new
    if self.equipped_armor and !self.equipped_armor.character_armor_attachments.blank?
      self.equipped_armor.character_armor_attachments.each do |caa|
        armor_attachment = ArmorAttachment.find(caa.armor_attachment_id)
        if armor_attachment.stat_bonus
          modification_bonuses['characteristics'] << armor_attachment.stat_bonus
        end
        if caa.armor_attachment_modification_options
          caa.armor_attachment_modification_options.each do |option|
            modification_option = ArmorAttachmentModificationOption.find(option)
            if modification_option.talent_id
              modification_bonuses['talents'] << modification_option.talent_id
            end
            if modification_option.skill_id
              modification_bonuses['skills'] << modification_option.skill_id
            end
          end
        end
      end
    end
    modification_bonuses
  end

  # Find equipped weapons.
  def equipped_weapons
    CharacterWeapon.where(:character_id => self.id, :equipped => :true).where('weapon_id != 12')
  end
  # All carried weapons, equipped first.
  def carried_weapons
    CharacterWeapon.where(:character_id => self.id, :carried => :true).order('equipped desc')
  end

  def inventory(options = {})
    inventory = Array.new

    if options[:type].nil? || options[:type].include?('gear')
      self.character_gears.each do |cg|
        if (options[:carried] && cg.carried) ||
          (!options[:carried] && !cg.carried) || options[:carried].nil?
          inventory << {
            :id => cg.id,
            :name => cg.gear.name,
            :description => cg.gear.description,
            :carried => cg.carried,
            :quantity => cg.qty,
            :total_encumbrance => cg.gear.encumbrance.nil? ? 0 : cg.gear.encumbrance * cg.qty, # calculate total
            :total_value => cg.gear.price.nil? ? 0 : cg.gear.price * cg.qty, # calculate total
            :location => nil,
            :custom => false,
            :type => 'gear',
          }
        end
      end
      self.character_custom_gears.each do |cg|
        if (options[:carried] && cg.carried) ||
          (!options[:carried] && !cg.carried) || options[:carried].nil?
          inventory << {
            :id => cg.id,
            :name => cg.description,
            :description => '',
            :carried => cg.carried,
            :quantity => cg.qty,
            :total_encumbrance => cg.encumbrance.nil? ? 0 : cg.encumbrance * cg.qty, # calculate total
            :total_value => '',
            :location => nil,
            :custom => true,
            :type => 'gear',
          }
        end
      end
    end

    if options[:type].nil? || options[:type].include?('weapon')
      self.character_weapons.each do |cg|
        if ((options[:carried] && cg.carried) || (!options[:carried] && !cg.carried) || options[:carried].nil?) && cg.weapon.name != 'Unarmed'
          if cg.weapon_model_id
            cg.weapon.name = WeaponModel.find(cg.weapon_model_id).name
          end
          inventory << {
            :id => cg.id,
            :name => cg.weapon.name,
            :description => cg.weapon.description,
            :carried => cg.carried,
            :quantity => 1,
            :total_encumbrance => cg.weapon.encumbrance, # calculate total
            :location => nil,
            :custom => false,
            :type => 'weapon',
          }
        end
      end
    end

    if options[:type].nil? || options[:type].include?('armor')
      self.character_armor.each do |cg|
        if (options[:carried] && cg.carried) || (!options[:carried] && !cg.carried) || options[:carried].nil?
          if cg.armor_model_id
            cg.armor.name = ArmorModel.find(cg.armor_model_id).name
          end
          if cg.character_armor_attachments.any?
            cg.armor.name = "Modified " + cg.armor.name
          end
          inventory << {
            :id => cg.id,
            :name => cg.armor.name,
            :description => cg.armor.description,
            :carried => cg.carried,
            :quantity => 1,
            :total_encumbrance => cg.armor.encumbrance, # calculate total
            :location => nil,
            :custom => false,
            :type => 'armor',
          }
        end
      end
    end

    inventory.sort_by{|e| e[:name]}
  end

  def weapon_modification_bonuses
    modification_bonuses = {}
    modification_bonuses['skills'] = Array.new
    modification_bonuses['talents'] = Array.new
    if self.equipped_weapons
      self.equipped_weapons.each do |equipped_weapon|
        equipped_weapon.character_weapon_attachments.each do |caa|
          if caa.weapon_attachment_modification_options
            caa.weapon_attachment_modification_options.each do |option|
              modification_option = WeaponAttachmentModificationOption.find(option)
              if modification_option.talent_id
                modification_bonuses['talents'] << modification_option.talent_id
              end
              if modification_option.skill_id
                modification_bonuses['skills'] << modification_option.skill_id
              end
            end
          end
        end
      end
    end
    modification_bonuses
  end

  private

  def log_starting_experience
    species = Race.find(self.race_id)

    # Add experience entry in the adventure log for species starting XP.
    AdventureLog.where(character_id: self.id, experience: species.starting_experience, date: self.created_at, log: "#{species.name} starting experience", user_id: 0).create
  end

  def set_species_stats
    species = Race.find(self.race_id)

    # Save species characteristics.
    ['brawn', 'agility', 'intellect', 'willpower', 'cunning', 'presence'].each do |stat|
      self.update_attribute(stat.to_sym, species[stat])
      # Save experience entries for species characteristics.
      CharactersController.helpers.set_experience_cost(self.id, stat, 0, species[stat], 'up', 'race')
    end

    # Save species talents.
    unless species.talents.nil?
      species.talents.each do |talent|
        character_bonus_talent = CharacterBonusTalent.new()
        character_bonus_talent.character_id = self.id
        character_bonus_talent.talent_id = talent.id
        character_bonus_talent.bonus_type = 'racial'
        character_bonus_talent.save

        # Save experience entry.
        CharactersController.helpers.set_experience_cost(self.id, 'talent', talent.id, 1, 'up', 'race')
      end
    end

    # Save fixed free species skill ranks.
    RaceSkill.where(:race_id => species.id).each do |race_skill|
      character_skill = CharacterSkill.where(:character_id => self.id, :skill_id => race_skill.skill_id).first
      unless character_skill.nil?
        character_skill.free_ranks_race = race_skill.ranks
        character_skill.save

        # Save experience entry.
        race_skill.ranks.times do |rank|
          CharactersController.helpers.set_experience_cost(self.id, 'skill', race_skill.skill_id, rank + 1, 'up', 'race')
        end
        CharacterStartingSkillRank.where(:character_id => self.id, :skill_id => race_skill.id, :granted_by => 'race', :ranks => race_skill.ranks).first_or_create
      end
    end
  end

  def save_unarmed_combat_entry
    # Save a weapon entry for unarmed combat.
    unarmed_weapon = Weapon.where(:name => 'Unarmed').first
    character_unarmed = CharacterWeapon.where(:character_id => self.id, :weapon_id => unarmed_weapon.id).first_or_create
    character_unarmed = CharacterWeapon.new()
    character_unarmed.character_id = self.id
    character_unarmed.weapon_id = unarmed_weapon.id
    character_unarmed.carried = true
    character_unarmed.equipped = true
    character_unarmed.save
  end

end
