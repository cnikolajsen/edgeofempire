# Armor model.
class Armor < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :slugged

  has_many :character_armors
  has_many :characters, through: :character_armors
  has_many :armor_models
  belongs_to :armor_category
  accepts_nested_attributes_for :armor_models, reject_if: :all_blank, allow_destroy: true

  has_many :armor_attachments_armors
  accepts_nested_attributes_for :armor_attachments_armors, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :armor_category_id, presence: true

  default_scope { order('name ASC') }

  def attachments
    attachments = []
    self.armor_attachments_armors.each do |waw|
      if waw.armor_attachment_id
        attachment = ArmorAttachment.find(waw.armor_attachment_id)
        if attachment.hard_points <= self.hard_points
          attachments << attachment
        end
      end
    end
    attachments
  end
end
