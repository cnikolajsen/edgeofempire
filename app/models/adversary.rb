# Adversary model.
class Adversary < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  after_create :save_unarmed_combat_entry
  after_create :set_species_stats

  belongs_to :race
  belongs_to :book

  has_many :adversary_skills, dependent: :destroy
  has_many :skills, -> { order 'skills.name' }, through: :adversary_skills
  has_many :adversary_armor, dependent: :destroy
  has_many :armors, through: :adversary_armor
  has_many :adversary_weapons, dependent: :destroy
  has_many :weapons, through: :adversary_weapons
  has_many :adversary_gears, dependent: :destroy
  has_many :gears, through: :adversary_gears
  has_many :adversary_custom_gears, dependent: :destroy

  accepts_nested_attributes_for :adversary_armor, reject_if: proc { |a| a['armor_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :adversary_weapons, reject_if: proc { |a| a['weapon_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :adversary_gears, reject_if: proc { |a| a['gear_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :adversary_custom_gears, allow_destroy: true

  validates :name, presence: true, uniqueness: true

  # Find equipped armor.
  def equipped_armor
    AdversaryArmor.where(adversary_id: id).first
  end

  # Find equipped weapons.
  def equipped_weapons
    AdversaryWeapon.where(adversary_id: id).where('weapon_id != 12')
  end

  def inventory(options = {})
    inventory = []

    #if options[:type].nil? || options[:type].include?('gear')
    #  self.adversary_gears.each do |cg|
    #      inventory << {
    #        id: cg.id,
    #        name: cg.gear.name,
    #        description: cg.gear.description,
    #        quantity: cg.qty,
    #        total_encumbrance: cg.gear.encumbrance.nil? ? 0 : cg.gear.encumbrance * cg.qty, # calculate total
    #        location: nil,
    #        custom: false,
    #        type: 'gear'
    #      }
    #    end
    #  self.adversary_custom_gears.each do |cg|
    #      inventory << {
    #        id: cg.id,
    #        name: cg.description,
    #        description: '',
    #        quantity: cg.qty,
    #        total_encumbrance: cg.encumbrance.nil? ? 0 : cg.encumbrance * cg.qty, # calculate total
    #        location: nil,
    #        custom: true,
    #        type: 'gear'
    #      }
    #    end
    #end

    if options[:type].nil? || options[:type].include?('weapon')
      adversary_weapons.each do |cg|
        next if cg.weapon.name == 'Unarmed'
        if cg.adversary_weapon_attachments.any?
          cg.weapon.name = "Modified #{cg.weapon.name}"
        end
        inventory << {
          id: cg.id,
          name: cg.weapon.name,
          description: cg.weapon.description,
          quantity: 1,
          total_encumbrance: cg.weapon.encumbrance, # calculate total
          location: nil,
          custom: false,
          type: 'weapon'
        }
      end
    end

    if options[:type].nil? || options[:type].include?('armor')
      adversary_armor.each do |cg|
        if cg.adversary_armor_attachments.any?
          cg.armor.name = "Modified #{cg.armor.name}"
        end
        inventory << {
          id: cg.id,
          name: cg.armor.name,
          description: cg.armor.description,
          quantity: 1,
          total_encumbrance: cg.armor.encumbrance, # calculate total
          location: nil,
          custom: false,
          type: 'armor'
        }
      end
    end

    inventory.sort_by { |e| e[:name] }
  end

  def attacks
    attacks = []
    # Build attacks list.
    if adversary_weapons
      adversary_weapons.each do |cw|
        next if cw.weapon.nil?

        @wq = []
        cw.weapon.weapon_quality_ranks.each do |q|
          @wq << {
            name: q.weapon_quality.name,
            ranks: q.ranks
          }
        end
#
        # adversary_skill = AdversarySkill.where("adversary_id = ? AND skill_id = ?", self.id, cw.weapon.skill.id).first
        # if adversary_skill.nil?
        ranks = 0
        # else
        #   ranks = adversary_skill.ranks + adversary_skill.free_ranks_race + adversary_skill.free_ranks_career + adversary_skill.free_ranks_specialization + adversary_skill.free_ranks_equipment
        # end
#
        if cw.weapon.skill.name == 'Brawl'
          cw.weapon.damage = brawn

          if cw.weapon.name == 'Unarmed'
            # Trandoshans have claws.
            if !race.nil? && race.name == 'Trandoshan'
              cw.weapon.name = 'Claws'
              cw.weapon.damage += 1
              cw.weapon.crit = 3
            end
          end

          unless talent_alterations.blank?
            talent_alterations.each  do |_talent_id, stat|
              stat.each do |type, value|
                cw.weapon.damage += value['count'] if type == :brawl_damage_bonus
              end
            end
          end
        end
#
    #    if cw.weapon.skill.name == 'Melee'
    #      talent_alterations.each do |_talent_id, stat|
    #        stat.each do |type, value|
    #          cw.weapon.damage += value['count'] if type == :melee_damage_bonus
    #        end
    #      end
    #    end
#
    #    unless cw.adversary_weapon_attachments.blank?
    #      cw.weapon.name = "Modified #{cw.weapon.name}"
    #    end
#
        weapon_attachment = Array.new
        cw.adversary_weapon_attachments.each do |cwa|
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
                  name: WeaponQuality.find_by_id(modification_option.weapon_quality_id).name,
                  ranks: wq_ranks,
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
#
          weapon_attachment << {
            name: WeaponAttachment.find(cwa.weapon_attachment_id).name,
            options: options
          }

        end
#
        attacks << {
          weapon: cw.weapon,
          skill: cw.weapon.skill,
          ranks: ranks,
          qualities: @wq,
          attachments: weapon_attachment
        }
      end
    end

    attacks
  end

  # Determine Soak. Brawn plus armor plus talents.
  def calculated_soak
    soak = brawn
    soak += equipped_armor.armor.soak if equipped_armor

    # Then increase based on selected talents.
    talent_alterations.each do |_talent_id, stat|
      stat.each do |type, value|
        soak += value['count'] if type == :soak
      end
    end

    cybernetics[:bonuses].each do |cb|
      soak += cb[1] if cb[0] == :soak
    end

    soak
  end

  def defense
    defense = 0
    defense += equipped_armor.armor.defense if equipped_armor
    defense
  end

  # Determine strain threshold. Species stat plus willpower.
  def calculated_strain
    strain_th = willpower
    strain_th += race.strain_threshold if race && race.strain_threshold
    # Then increase based on selected talents.
    talent_alterations.each do |_talent_id, stat|
      stat.each do |type, value|
        strain_th += value['count'] if type == :strain
      end
    end
    strain_th
  end

  # Determine starting wound threshold. Species stat plus brawn.
  def calculated_wounds
    wound_th = brawn
    wound_th += race.wound_threshold if race && race.wound_threshold
    # Then increase based on selected talents.
    talent_alterations.each do |_talent_id, stat|
      stat.each do |type, value|
        wound_th += value if type == :wound
      end
    end
    wound_th
  end

  def set_species_stats
    species = Race.find(race_id) if race_id

    # # Save species talents.
    # unless species.talents.nil?
    #   species.talents.each do |talent|
    #     adversary_bonus_talent = AdversaryBonusTalent.new()
    #     adversary_bonus_talent.adversary_id = self.id
    #     adversary_bonus_talent.talent_id = talent.id
    #     adversary_bonus_talent.bonus_type = 'racial'
    #     adversary_bonus_talent.save
    #
    #     # Save experience entry.
    #     AdversariesController.helpers.set_experience_cost(self.id, 'talent', talent.id, 1, 'up', 'race')
    #   end
    # end

    # Save fixed free species skill ranks.
    # RaceSkill.where(race_id: species.id).each do |race_skill|
    #   adversary_skill = AdversarySkill.where(adversary_id: id, skill_id: race_skill.skill_id).first
    #   next if adversary_skill.nil?
    #
    #   adversary_skill.free_ranks_race = race_skill.ranks
    #   adversary_skill.save
    #
    #   AdversaryStartingSkillRank.where(adversary_id: id, skill_id: race_skill.id, granted_by: 'race', ranks: race_skill.ranks).first_or_create
    # end
  end

  def save_unarmed_combat_entry
    # Save a weapon entry for unarmed combat.
    unarmed_weapon = Weapon.where(name: 'Unarmed').first
    # adversary_unarmed = AdversaryWeapon.where(adversary_id: id, weapon_id: unarmed_weapon.id).first_or_create
    adversary_unarmed = AdversaryWeapon.new
    adversary_unarmed.adversary_id = id
    adversary_unarmed.weapon_id = unarmed_weapon.id
    adversary_unarmed.save
  end

  def talent_alterations
    # talent_alterations = {}
    # talents.each do |id, count|
    #   talent = Talent.find(id)
    #   name = talent.name.gsub(' ', '').downcase
    #   if talent.respond_to?("#{name}")
    #     talent_alterations[id] = {}
    #     talent_alterations[id] = talent.send("#{name}", count, self)
    #   end
    # end
#
    # talent_alterations
  end
end
