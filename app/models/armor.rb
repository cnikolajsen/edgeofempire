class Armor < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  has_many :character_armors
  has_many :characters, :through => :character_armors
  has_many :armor_models
  belongs_to :armor_category
  accepts_nested_attributes_for :armor_models, :reject_if => :all_blank, :allow_destroy => true

  has_many :armor_attachments_armors
  accepts_nested_attributes_for :armor_attachments_armors, :reject_if => :all_blank, :allow_destroy => true

  #has_many :armor_attachments_groups
  #has_many :attachment_groups, :through => :armor_attachments_groups
  #accepts_nested_attributes_for :armor_attachments_groups, :reject_if => :all_blank, :allow_destroy => true

  default_scope { order('name ASC') }

  def attachments
    attachments = Array.new
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
