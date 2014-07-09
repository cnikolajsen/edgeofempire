class Weapon < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  belongs_to :skill
  has_many :weapon_qualities, :through => :weapon_quality_ranks
  has_many :weapon_quality_ranks
  accepts_nested_attributes_for :weapon_quality_ranks
  has_many :characters, :through => :character_weapons
  has_many :character_weapons
  has_many :weapon_models
  belongs_to :weapon_category
  accepts_nested_attributes_for :weapon_models, :reject_if => :all_blank, :allow_destroy => true

  has_many :weapon_attachments_weapons
  accepts_nested_attributes_for :weapon_attachments_weapons, :reject_if => :all_blank, :allow_destroy => true

  has_many :weapon_attachments_groups
  has_many :attachment_groups, :through => :weapon_attachments_groups
  accepts_nested_attributes_for :weapon_attachments_groups, :reject_if => :all_blank, :allow_destroy => true

  def attachments
    attachments = Array.new
    self.weapon_attachments_groups.each do |wag|
      WeaponAttachmentAttachmentsGroup.where(:attachment_group_id => wag.attachment_group.id).each do |waag|
        if waag.weapon_attachment_id
          attachment = WeaponAttachment.find(waag.weapon_attachment_id)
          if attachment.hard_points <= self.hard_points
            attachments << attachment
          end
        end
      end
    end
    attachments
  end

end
