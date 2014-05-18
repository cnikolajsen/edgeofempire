class Character < ActiveRecord::Base
  validates :name, presence: true
  validates :race_id, presence: true
  validates :career_id, presence: true

  include AASM
  include FriendlyId
  friendly_id :slug_candidates, :use => :slugged

  def slug_candidates
    [
      :name,
      [:name, :race_id],
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
    starting_experience = if !@character.race.nil? then @character.race.starting_experience else 0 end
    available_experience = starting_experience + @character.experience

    if @character.race.nil? or @character.career.nil?
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
  has_many :character_obligations, :dependent => :destroy
  has_many :obligations, :through => :character_obligations
  has_many :character_motivations, :dependent => :destroy
  has_many :motivations, :through => :character_motivations
  has_many :character_force_powers, :dependent => :destroy
  has_many :force_powers, :through => :character_force_powers

  has_many :character_talents, :dependent => :destroy
  has_many :talents, :through => :character_talents

  has_many :character_bonus_talents, :dependent => :destroy
  has_many :character_starting_skill_ranks, :dependent => :destroy

  has_many :character_experience_costs

  belongs_to :race
  belongs_to :career

  accepts_nested_attributes_for :character_skills, :allow_destroy => true
  accepts_nested_attributes_for :character_armor, :reject_if => proc { |a| a['armor_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_weapons, :reject_if => proc { |a| a['weapon_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_gears, :reject_if => proc { |a| a['gear_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_force_powers, :reject_if => proc { |a| a['force_power_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :character_obligations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_motivations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :character_talents, :allow_destroy => true
  accepts_nested_attributes_for :character_starting_skill_ranks, :allow_destroy => true

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

  def free_skill_ranks_career
    career_free_skill_ranks = if self.race.name == 'Droid' then 6 else 4 end
  end

  def free_skill_ranks_specialization
    specialization_free_skill_ranks = if self.race.name == 'Droid' then 3 else 2 end
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
      if Talent.find(talent.resource_id).name == "Force Rating"
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
      unless cw.weapon.nil?
        @wq = Array.new
        cw.weapon.weapon_quality_ranks.each do |q|
          ranks = nil
          if q.ranks > 0
            ranks = q.ranks
          end
          @wq << {
            'name' => q.weapon_quality.name,
            'ranks' => ranks,
          }
        end

        character_skill_ranks = CharacterSkill.where("character_id = ? AND skill_id = ?", self.id, cw.weapon.skill.id)
        if character_skill_ranks.first.nil?
          ranks = 0
        else
          ranks =  character_skill_ranks.first.ranks
        end

        if cw.weapon.skill.name == 'Brawl'
          cw.weapon.damage = self.brawn

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
          self.talent_alterations.each do |talent_id, stat|
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
                  'name' => WeaponQuality.find_by_id(modification_option.weapon_quality_id).name,
                  'ranks' => wq_ranks,
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
            'name' => WeaponAttachment.find(cwa.weapon_attachment_id).name,
            'options' => options,
          }

        end

        #attachment_text = nil
        #unless weapon_attachment.blank?
        #  attachment_text = "; [<strong>Attachments:</strong> #{weapon_attachment.join(', ')}]"
        #end

        #if params[:format] != 'pdf'
          #dice = render_to_string "_dice_pool", :locals => {:score => self.send(cw.weapon.skill.characteristic.downcase), :ranks => ranks}, :layout => false

          #attacks << "<strong>#{cw.weapon.name}</strong> (#{cw.weapon.skill.name} #{dice}; Damage: #{cw.weapon.damage}; Critical: #{cw.weapon.crit}; Range: #{cw.weapon.range}; #{@wq.join(', ')}#{attachment_text})"
        #end
      end

      attacks << {
        'weapon' => cw.weapon,
        'skill' => cw.weapon.skill,
        'ranks' => ranks,
        'qualities' => @wq,
        'attachments' => weapon_attachment,
      }
    end

    attacks
  end

  def talent_alterations
    talent_alterations = {}
    self.talents.each do |id, count|
      talent = Talent.find(id)
      name = talent.name.gsub(' ', '').downcase
      if talent.respond_to?("#{name}")
        talent_alterations[id] = {}
        talent_alterations[id] = talent.send("#{name}", count)
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
    CharacterWeapon.where(:character_id => self.id, :equipped => :true)
  end
  # All carried weapons, equipped first.
  def carried_weapons
    CharacterWeapon.where(:character_id => self.id, :carried => :true).order('equipped desc')
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

end
